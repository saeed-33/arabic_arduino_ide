# Generated from ArArduinoParser.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .ArArduinoParser import ArArduinoParser
else:
    from ArArduinoParser import ArArduinoParser

# This class defines a complete generic visitor for a parse tree produced by ArArduinoParser.

class ArArduinoParserVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by ArArduinoParser#program.
    def visitProgram(self, ctx:ArArduinoParser.ProgramContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#declaration.
    def visitDeclaration(self, ctx:ArArduinoParser.DeclarationContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#varDecl.
    def visitVarDecl(self, ctx:ArArduinoParser.VarDeclContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#funDecl.
    def visitFunDecl(self, ctx:ArArduinoParser.FunDeclContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#funcBody.
    def visitFuncBody(self, ctx:ArArduinoParser.FuncBodyContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#params.
    def visitParams(self, ctx:ArArduinoParser.ParamsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#param.
    def visitParam(self, ctx:ArArduinoParser.ParamContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#block.
    def visitBlock(self, ctx:ArArduinoParser.BlockContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#statement.
    def visitStatement(self, ctx:ArArduinoParser.StatementContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#idStatement.
    def visitIdStatement(self, ctx:ArArduinoParser.IdStatementContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#idSuffix.
    def visitIdSuffix(self, ctx:ArArduinoParser.IdSuffixContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#ifStat.
    def visitIfStat(self, ctx:ArArduinoParser.IfStatContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#whileStat.
    def visitWhileStat(self, ctx:ArArduinoParser.WhileStatContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#returnStat.
    def visitReturnStat(self, ctx:ArArduinoParser.ReturnStatContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#args.
    def visitArgs(self, ctx:ArArduinoParser.ArgsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#expression.
    def visitExpression(self, ctx:ArArduinoParser.ExpressionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#orExpr.
    def visitOrExpr(self, ctx:ArArduinoParser.OrExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#andExpr.
    def visitAndExpr(self, ctx:ArArduinoParser.AndExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#bwOrExpr.
    def visitBwOrExpr(self, ctx:ArArduinoParser.BwOrExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#bwXorExpr.
    def visitBwXorExpr(self, ctx:ArArduinoParser.BwXorExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#bwAndExpr.
    def visitBwAndExpr(self, ctx:ArArduinoParser.BwAndExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#relExpr.
    def visitRelExpr(self, ctx:ArArduinoParser.RelExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#relOp.
    def visitRelOp(self, ctx:ArArduinoParser.RelOpContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#addExpr.
    def visitAddExpr(self, ctx:ArArduinoParser.AddExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#mulExpr.
    def visitMulExpr(self, ctx:ArArduinoParser.MulExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#unaryExpr.
    def visitUnaryExpr(self, ctx:ArArduinoParser.UnaryExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#primary.
    def visitPrimary(self, ctx:ArArduinoParser.PrimaryContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#primaryIdSuffix.
    def visitPrimaryIdSuffix(self, ctx:ArArduinoParser.PrimaryIdSuffixContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ArArduinoParser#type.
    def visitType(self, ctx:ArArduinoParser.TypeContext):
        return self.visitChildren(ctx)



del ArArduinoParser