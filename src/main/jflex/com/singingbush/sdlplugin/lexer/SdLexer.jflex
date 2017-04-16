package com.singingbush.sdlplugin.lexer;

import com.intellij.lexer.*;
import com.intellij.psi.tree.IElementType;

%%

%{

  private int nestedCommentDepth = 0;
  private int blockCommentDepth = 0;

  public SdlLexer() {
    this((java.io.Reader)null);
  }
%}

%public
%class SdlLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode

EOL = "\n"
WHITE_SPACE_CHAR = [\ \t\f]
NEW_LINE = [\n\r]+
// maybe better off making NEW_LINE = [^\n]*

LETTER = [:letter:]
DIGIT = [:digit:]
ID = (_|{LETTER}) (_|{DIGIT}|{LETTER})*

LINE_COMMENT="//".*

BLOCK_COMMENT_START = "/*"
BLOCK_COMMENT_END = "*/"

%xstate BRACES, VALUE, VALUE_OR_KEY, VALUE_BRACE, INDENT_VALUE
// %state WAITING_VALUE, NESTING_COMMENT_CONTENT BLOCK_COMMENT_CONTENT

%%

<YYINITIAL> {WHITE_SPACE_CHAR}+ { return com.intellij.psi.TokenType.WHITE_SPACE; }
<YYINITIAL> {NEW_LINE}+         { return com.intellij.psi.TokenType.WHITE_SPACE; }

<YYINITIAL, BRACES, VALUE, VALUE_BRACE, VALUE_OR_KEY> {
    ";" {
        return EOL
    }
}
