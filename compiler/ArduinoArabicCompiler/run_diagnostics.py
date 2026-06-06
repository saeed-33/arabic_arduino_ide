from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from antlr4 import CommonTokenStream, FileStream, InputStream
from antlr4.error.ErrorListener import ErrorListener
from antlr4.Token import Token
from antlr4.tree.Tree import TerminalNodeImpl

from ArArduinoLexer import ArArduinoLexer
from ArArduinoParser import ArArduinoParser


@dataclass(frozen=True)
class SyntaxErrorInfo:
    line: int
    column: int
    message: str


class CollectingErrorListener(ErrorListener):
    def __init__(self) -> None:
        super().__init__()
        self.errors: list[SyntaxErrorInfo] = []

    def syntaxError(
        self,
        recognizer: Any,
        offendingSymbol: Any,
        line: int,
        column: int,
        msg: str,
        e: Exception | None,
    ) -> None:
        self.errors.append(SyntaxErrorInfo(line=line, column=column, message=msg))


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Emit Arduino Arabic compiler diagnostics as JSON."
    )
    parser.add_argument("--file", help="Arabic source file to analyze.")
    parser.add_argument("--source", help="Arabic source text to analyze.")
    args = parser.parse_args()

    if not args.file and args.source is None:
        parser.error("Provide --file or --source.")

    if args.file:
        input_stream = FileStream(args.file, encoding="utf-8")
        source_label = str(Path(args.file))
    else:
        input_stream = InputStream(args.source)
        source_label = "<inline>"

    lexer_errors = CollectingErrorListener()
    parser_errors = CollectingErrorListener()

    lexer = ArArduinoLexer(input_stream)
    lexer.removeErrorListeners()
    lexer.addErrorListener(lexer_errors)

    token_stream = CommonTokenStream(lexer)
    token_stream.fill()

    parser_instance = ArArduinoParser(token_stream)
    parser_instance.removeErrorListeners()
    parser_instance.addErrorListener(parser_errors)

    parse_tree = parser_instance.program()

    payload = {
        "compiler": {
            "name": "ArduinoArabicCompiler",
            "source": source_label,
            "parser": "ANTLR4 Python",
        },
        "tokens": _tokens_to_json(token_stream.tokens, lexer.symbolicNames),
        "parseTree": _parse_tree_to_json(parse_tree, parser_instance),
        "rawDiagnostics": _errors_to_json(lexer_errors.errors, "LEXER")
        + _errors_to_json(parser_errors.errors, "PARSER"),
        "generatedCode": [],
        "buildStages": [
            {
                "name": "Lexing",
                "status": "ready",
                "durationLabel": "--",
                "details": "Token stream emitted by ArArduinoLexer.",
            },
            {
                "name": "Parsing",
                "status": "ready"
                if not lexer_errors.errors and not parser_errors.errors
                else "blocked",
                "durationLabel": "--",
                "details": "Parse tree emitted by ArArduinoParser.program.",
            },
            {
                "name": "Code generation",
                "status": "blocked",
                "durationLabel": "--",
                "details": "Code generation is not implemented in the provided compiler snapshot.",
            },
        ],
        "internalLogs": [
            "[compiler] ArArduinoLexer.g4 loaded.",
            "[compiler] ArArduinoParser.g4 loaded.",
            "[compiler] JSON diagnostics emitted.",
        ],
    }

    json.dump(payload, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write("\n")
    return 0 if not payload["rawDiagnostics"] else 1


def _tokens_to_json(tokens: list[Token], symbolic_names: list[str]) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for token in tokens:
        if token.type == Token.EOF:
            continue

        token_type = (
            symbolic_names[token.type]
            if 0 <= token.type < len(symbolic_names) and symbolic_names[token.type]
            else str(token.type)
        )
        result.append(
            {
                "type": token_type,
                "lexeme": token.text,
                "line": token.line,
                "column": token.column,
            }
        )
    return result


def _parse_tree_to_json(node: Any, parser_instance: ArArduinoParser) -> dict[str, Any]:
    if isinstance(node, TerminalNodeImpl):
        symbol = node.getSymbol()
        return {
            "rule": _token_name(symbol.type, parser_instance),
            "text": node.getText(),
            "line": symbol.line,
            "column": symbol.column,
            "children": [],
        }

    children = [_parse_tree_to_json(node.getChild(i), parser_instance) for i in range(node.getChildCount())]
    return {
        "rule": parser_instance.ruleNames[node.getRuleIndex()],
        "text": node.getText(),
        "line": _first_line(children),
        "column": _first_column(children),
        "children": children,
    }


def _token_name(token_type: int, parser_instance: ArArduinoParser) -> str:
    names = parser_instance.symbolicNames
    if 0 <= token_type < len(names) and names[token_type]:
        return names[token_type]
    return str(token_type)


def _first_line(children: list[dict[str, Any]]) -> int:
    for child in children:
        if child["line"] > 0:
            return child["line"]
    return 1


def _first_column(children: list[dict[str, Any]]) -> int:
    for child in children:
        if child["column"] >= 0:
            return child["column"]
    return 0


def _errors_to_json(
    errors: list[SyntaxErrorInfo], source: str
) -> list[dict[str, Any]]:
    return [
        {
            "code": f"{source}_SYNTAX_ERROR",
            "message": error.message,
            "severity": "error",
            "line": error.line,
            "column": error.column,
            "context": source,
        }
        for error in errors
    ]


if __name__ == "__main__":
    raise SystemExit(main())
