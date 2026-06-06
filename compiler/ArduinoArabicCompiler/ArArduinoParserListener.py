# Generated from ArArduinoParser.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .ArArduinoParser import ArArduinoParser
else:
    from ArArduinoParser import ArArduinoParser

# This class defines a complete listener for a parse tree produced by ArArduinoParser.
class ArArduinoParserListener(ParseTreeListener):

    # Enter a parse tree produced by ArArduinoParser#program.
    def enterProgram(self, ctx:ArArduinoParser.ProgramContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#program.
    def exitProgram(self, ctx:ArArduinoParser.ProgramContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#declaration.
    def enterDeclaration(self, ctx:ArArduinoParser.DeclarationContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#declaration.
    def exitDeclaration(self, ctx:ArArduinoParser.DeclarationContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#varDecl.
    def enterVarDecl(self, ctx:ArArduinoParser.VarDeclContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#varDecl.
    def exitVarDecl(self, ctx:ArArduinoParser.VarDeclContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#funDecl.
    def enterFunDecl(self, ctx:ArArduinoParser.FunDeclContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#funDecl.
    def exitFunDecl(self, ctx:ArArduinoParser.FunDeclContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#funcBody.
    def enterFuncBody(self, ctx:ArArduinoParser.FuncBodyContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#funcBody.
    def exitFuncBody(self, ctx:ArArduinoParser.FuncBodyContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#params.
    def enterParams(self, ctx:ArArduinoParser.ParamsContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#params.
    def exitParams(self, ctx:ArArduinoParser.ParamsContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#param.
    def enterParam(self, ctx:ArArduinoParser.ParamContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#param.
    def exitParam(self, ctx:ArArduinoParser.ParamContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#block.
    def enterBlock(self, ctx:ArArduinoParser.BlockContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#block.
    def exitBlock(self, ctx:ArArduinoParser.BlockContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#statement.
    def enterStatement(self, ctx:ArArduinoParser.StatementContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#statement.
    def exitStatement(self, ctx:ArArduinoParser.StatementContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#idStatement.
    def enterIdStatement(self, ctx:ArArduinoParser.IdStatementContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#idStatement.
    def exitIdStatement(self, ctx:ArArduinoParser.IdStatementContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#idSuffix.
    def enterIdSuffix(self, ctx:ArArduinoParser.IdSuffixContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#idSuffix.
    def exitIdSuffix(self, ctx:ArArduinoParser.IdSuffixContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#ifStat.
    def enterIfStat(self, ctx:ArArduinoParser.IfStatContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#ifStat.
    def exitIfStat(self, ctx:ArArduinoParser.IfStatContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#whileStat.
    def enterWhileStat(self, ctx:ArArduinoParser.WhileStatContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#whileStat.
    def exitWhileStat(self, ctx:ArArduinoParser.WhileStatContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#returnStat.
    def enterReturnStat(self, ctx:ArArduinoParser.ReturnStatContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#returnStat.
    def exitReturnStat(self, ctx:ArArduinoParser.ReturnStatContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#args.
    def enterArgs(self, ctx:ArArduinoParser.ArgsContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#args.
    def exitArgs(self, ctx:ArArduinoParser.ArgsContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#expression.
    def enterExpression(self, ctx:ArArduinoParser.ExpressionContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#expression.
    def exitExpression(self, ctx:ArArduinoParser.ExpressionContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#orExpr.
    def enterOrExpr(self, ctx:ArArduinoParser.OrExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#orExpr.
    def exitOrExpr(self, ctx:ArArduinoParser.OrExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#andExpr.
    def enterAndExpr(self, ctx:ArArduinoParser.AndExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#andExpr.
    def exitAndExpr(self, ctx:ArArduinoParser.AndExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#bwOrExpr.
    def enterBwOrExpr(self, ctx:ArArduinoParser.BwOrExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#bwOrExpr.
    def exitBwOrExpr(self, ctx:ArArduinoParser.BwOrExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#bwXorExpr.
    def enterBwXorExpr(self, ctx:ArArduinoParser.BwXorExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#bwXorExpr.
    def exitBwXorExpr(self, ctx:ArArduinoParser.BwXorExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#bwAndExpr.
    def enterBwAndExpr(self, ctx:ArArduinoParser.BwAndExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#bwAndExpr.
    def exitBwAndExpr(self, ctx:ArArduinoParser.BwAndExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#relExpr.
    def enterRelExpr(self, ctx:ArArduinoParser.RelExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#relExpr.
    def exitRelExpr(self, ctx:ArArduinoParser.RelExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#relOp.
    def enterRelOp(self, ctx:ArArduinoParser.RelOpContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#relOp.
    def exitRelOp(self, ctx:ArArduinoParser.RelOpContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#addExpr.
    def enterAddExpr(self, ctx:ArArduinoParser.AddExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#addExpr.
    def exitAddExpr(self, ctx:ArArduinoParser.AddExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#mulExpr.
    def enterMulExpr(self, ctx:ArArduinoParser.MulExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#mulExpr.
    def exitMulExpr(self, ctx:ArArduinoParser.MulExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#unaryExpr.
    def enterUnaryExpr(self, ctx:ArArduinoParser.UnaryExprContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#unaryExpr.
    def exitUnaryExpr(self, ctx:ArArduinoParser.UnaryExprContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#primary.
    def enterPrimary(self, ctx:ArArduinoParser.PrimaryContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#primary.
    def exitPrimary(self, ctx:ArArduinoParser.PrimaryContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#primaryIdSuffix.
    def enterPrimaryIdSuffix(self, ctx:ArArduinoParser.PrimaryIdSuffixContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#primaryIdSuffix.
    def exitPrimaryIdSuffix(self, ctx:ArArduinoParser.PrimaryIdSuffixContext):
        pass


    # Enter a parse tree produced by ArArduinoParser#type.
    def enterType(self, ctx:ArArduinoParser.TypeContext):
        pass

    # Exit a parse tree produced by ArArduinoParser#type.
    def exitType(self, ctx:ArArduinoParser.TypeContext):
        pass



del ArArduinoParser