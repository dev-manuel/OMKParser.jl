/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Linkoping University,
 * Department of Computer and Information Science,
 * SE-58183 Linkoping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3
 * AND THIS OSMC PUBLIC LICENSE (OSMC-PL).
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S
 * ACCEPTANCE OF THE OSMC PUBLIC LICENSE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from Linkoping University, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS
 * OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */
grammar Modelica;

options {
  ASTLabelType = pANTLR3_BASE_TREE;
  language = C;
}

import MetaModelica_Lexer; /* Makes all tokens defined, imported in OptiMo_Lexer */
//import ParModelica_Lexer; /* Makes all tokens defined, except the ones specific to MetaModelica */
//import OptiMo_Lexer;  /* Makes all tokens defined */

scope omc{
  int numPushed;
}

@includes {

  #if defined(_WIN32)
  #include <winsock2.h>
  #endif

  #include <stdlib.h>
  #include <stdio.h>
  #include <errno.h>
  #include <time.h>
  
  typedef struct fileinfo_struct {
    int line1;
    int line2;
    int offset1;
    int offset2;
  } fileinfo;
  
  #define false 0
  #define true 1
  #define token_to_scon(tok) mmc_mk_scon((char*)tok->getText(tok)->chars)

  #define ModelicaParserException 100
  #define ModelicaLexerException  200
  #define modelicaParserAssert(cond,msg,func,_line1,_offset1,_line2,_offset2) {if (!(cond)) { \
fileinfo* __info = (fileinfo*)malloc(sizeof(fileinfo)); \
CONSTRUCTEX(); \
EXCEPTION->type = ModelicaParserException; \
EXCEPTION->message = (void *) (msg); \
__info->line1 = _line1; \
__info->line2 = _line2; \
__info->offset1 = _offset1; \
__info->offset2 = _offset2; \
EXCEPTION->custom = __info; \
goto rule ## func ## Ex; }}

  #define make_redeclare_keywords(replaceable,redeclare) (((replaceable) && (redeclare)) ? MKAbsyn__REDECLARE_5fREPLACEABLE : ((replaceable) ? MKAbsyn__REPLACEABLE : ((redeclare) ? MKAbsyn__REDECLARE : NULL)))
  #define make_inner_outer(i,o) (i && o ? MKAbsyn__INNER_5fOUTER : i ? MKAbsyn__INNER : o ? MKAbsyn__OUTER : MKAbsyn__NOT_5fINNER_5fOUTER)

  #include "ModelicaParserCommon.h"

  /* Julia */
  #define PARSER_INFO(start) (SourceInfo__SOURCEINFO(ModelicaParser_filename_OMC, ModelicaParser_readonly, start->line, start->line == 1 ? start->charPosition+2 : start->charPosition+1, LT(1)->line, LT(1)->charPosition+1, 0.0))
  #define isCref(X) jl_typeis(X, MKAbsyn_Exp_CREF_type)
  #define isPath(X) jl_typeis(X, MKAbsyn_TypeSpec_TPATH_type)
  #define isComplex(X) jl_typeis(X, MKAbsyn_TypeSpec_TCOMPLEX_type)
  #define isTuple(X) jl_typeis(X, MKAbsyn_Exp_TUPLE_type)
  #define isCall(X) jl_typeis(X, MKAbsyn_Exp_CALL_type)
  #define isNotNil(X) !listEmpty(X)
  #define mmc_mk_cons(X, Y) (__mmc_mk_cons((jl_value_t *)X, (jl_value_t *)Y))
  #define GlobalScript__IALG(X) NULL
  #define GlobalScript__IEXP(X, Y) NULL
  #define GlobalScript__ISTMTS(X, Y) NULL

  #if !defined(JL_GC_PUSH7)
  #define JL_GC_PUSH7(arg1, arg2, arg3, arg4, arg5, arg6, arg7)                                           \
    void *__gc_stkf[] = {(void*)JL_GC_ENCODE_PUSH(7), jl_pgcstack, arg1, arg2, arg3, arg4, arg5, arg6, arg7}; \
    jl_pgcstack = (jl_gcframe_t*)__gc_stkf;
  #endif
  #if !defined(JL_GC_PUSH8)
  #define JL_GC_PUSH8(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)                      \
    void *__gc_stkf[] = {(void*)JL_GC_ENCODE_PUSH(8), jl_pgcstack, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8}; \
    jl_pgcstack = (jl_gcframe_t*)__gc_stkf;
  #endif
  #if !defined(JL_GC_PUSH9)
  #define JL_GC_PUSH9(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)                      \
    void *__gc_stkf[] = {(void*)JL_GC_ENCODE_PUSH(9), jl_pgcstack, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9}; \
    jl_pgcstack = (jl_gcframe_t*)__gc_stkf;
  #endif
  #if !defined(JL_GC_PUSH10)
  #define JL_GC_PUSH10(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)                      \
    void *__gc_stkf[] = {(void*)JL_GC_ENCODE_PUSH(10), jl_pgcstack, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10}; \
    jl_pgcstack = (jl_gcframe_t*)__gc_stkf;
  #endif
  #if !defined(JL_GC_PUSH11)
  #define JL_GC_PUSH11(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)                      \
    void *__gc_stkf[] = {(void*)JL_GC_ENCODE_PUSH(11), jl_pgcstack, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11}; \
    jl_pgcstack = (jl_gcframe_t*)__gc_stkf;
  #endif

  /* uncomment this to stress test the code by doing gc at each function start
   * 0 = auto, 1 = full, 2 = incremental
   */
  #define jlgc() /* jl_gc_collect(rand() \% 2) */
  #define OM_PUSHZ1(A) (A) = NULL; jlgc(); JL_GC_PUSH1(&(A)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ2(A,B) (A) = NULL; (B) = NULL; jlgc(); JL_GC_PUSH2(&(A),&(B)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ3(A,B,C) (A) = NULL; (B) = NULL; (C) = NULL; jlgc(); JL_GC_PUSH3(&(A),&(B),&(C)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ4(A,B,C,D) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; jlgc(); JL_GC_PUSH4(&(A),&(B),&(C),&(D)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ5(A,B,C,D,E) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; jlgc(); JL_GC_PUSH5(&(A),&(B),&(C),&(D),&(E)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ6(A,B,C,D,E,F) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; (F) = NULL; jlgc(); JL_GC_PUSH6(&(A),&(B),&(C),&(D),&(E),&(F)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ7(A,B,C,D,E,F,G) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; (F) = NULL; (G) = NULL; jlgc(); JL_GC_PUSH7(&(A),&(B),&(C),&(D),&(E),&(F),&(G)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ8(A,B,C,D,E,F,G,H) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; (F) = NULL; (G) = NULL; (H) = NULL; jlgc(); JL_GC_PUSH8(&(A),&(B),&(C),&(D),&(E),&(F),&(G),&(H)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ9(A,B,C,D,E,F,G,H,I) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; (F) = NULL; (G) = NULL; (H) = NULL; (I) = NULL; jlgc(); JL_GC_PUSH9(&(A),&(B),&(C),&(D),&(E),&(F),&(G),&(H),&(I)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ10(A,B,C,D,E,F,G,H,I,J) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; (F) = NULL; (G) = NULL; (H) = NULL; (I) = NULL; (J) = NULL; jlgc(); JL_GC_PUSH10(&(A),&(B),&(C),&(D),&(E),&(F),&(G),&(H),&(I),&(J)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_PUSHZ11(A,B,C,D,E,F,G,H,I,J,K) (A) = NULL; (B) = NULL; (C) = NULL; (D) = NULL; (E) = NULL; (F) = NULL; (G) = NULL; (H) = NULL; (I) = NULL; (J) = NULL; (K) = NULL; jlgc(); JL_GC_PUSH11(&(A),&(B),&(C),&(D),&(E),&(F),&(G),&(H),&(I),&(J),&(K)); ctx->pModelicaParser_omcTop->numPushed+=1;
  #define OM_POP(NN) ctx->pModelicaParser_omcTop->numPushed=ctx->pModelicaParser_omcTop->numPushed-1; JL_GC_POP();
}

@members
{
  #define ARRAY_REDUCTION_NAME "\$array"

  /* Julia */
  #include "OpenModelicaJuliaHeader.h"
  #include "MetaModelicaJuliaLayer.h"
}

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

stored_definition returns [void* ast]
@init{ $omc::numPushed; OM_PUSHZ2(within, cl); } :
  BOM? (within=within_clause SEMICOLON)?
  cl=class_definition_list?
  EOF
    {
      ast = MKAbsyn__PROGRAM(or_nil(cl), within ? within : MKAbsyn__TOP);
    }
  ;
  finally{ OM_POP(2); }

within_clause returns [void* ast]
@init{ OM_PUSHZ1(name); } :
  WITHIN (name=name_path)? {ast = name ? MKAbsyn__WITHIN(name) : MKAbsyn__TOP; }
  ;
  finally{ OM_POP(1); }

class_definition_list returns [void* ast]
@init{ f = NULL; OM_PUSHZ2(cd.ast, cl); } :
  ((f=FINAL)? cd=class_definition[f != NULL] SEMICOLON) cl=class_definition_list?
    {
      ast = mmc_mk_cons_typed(MKAbsyn_Class, cd.ast, or_nil(cl));
    }
  ;
  finally{ OM_POP(2); }

class_definition [int final] returns [void* ast]
@init{ e = 0; p = 0; OM_PUSHZ4(ct, cs.ast, $cs.name, $ast); } :
  ((e=ENCAPSULATED)? (p=PARTIAL)? ct=class_type cs=class_specifier)
    {
      $ast = MKAbsyn__CLASS($cs.name, mmc_mk_bcon(p), mmc_mk_bcon(final), mmc_mk_bcon(e), ct, $cs.ast, PARSER_INFO($start));
    }
  ;
  finally{ OM_POP(4); }

class_type returns [void* ast]
@init{ e = 0;  pur = 0; impur = 0; opr = 0; prl = 0; ker = 0; r = 0; } :
  ( CLASS { ast = MKAbsyn__R_5fCLASS; }
  | OPTIMIZATION { ast = MKAbsyn__R_5fOPTIMIZATION; }
  | MODEL { ast = MKAbsyn__R_5fMODEL; }
  | RECORD { ast = MKAbsyn__R_5fRECORD; }
  | BLOCK { ast = MKAbsyn__R_5fBLOCK; }
  | ( e=EXPANDABLE )? CONNECTOR { ast = e ? MKAbsyn__R_5fEXP_5fCONNECTOR : MKAbsyn__R_5fCONNECTOR; }
  | TYPE { ast = MKAbsyn__R_5fTYPE; }
  | T_PACKAGE { ast = MKAbsyn__R_5fPACKAGE; }
  | (pur=PURE | impur=IMPURE)? (opr=OPERATOR | prl=T_PARALLEL | ker=T_KERNEL)? FUNCTION
      {
        ast = opr ? MKAbsyn__R_5fFUNCTION(MKAbsyn__FR_5fOPERATOR_5fFUNCTION) :
              prl ? MKAbsyn__R_5fFUNCTION(MKAbsyn__FR_5fPARALLEL_5fFUNCTION) :
              ker ? MKAbsyn__R_5fFUNCTION(MKAbsyn__FR_5fKERNEL_5fFUNCTION) :
              pur ? MKAbsyn__R_5fFUNCTION(MKAbsyn__FR_5fNORMAL_5fFUNCTION(MKAbsyn__PURE)) :
              impur ? MKAbsyn__R_5fFUNCTION(MKAbsyn__FR_5fNORMAL_5fFUNCTION(MKAbsyn__IMPURE)) :
              MKAbsyn__R_5fFUNCTION(MKAbsyn__FR_5fNORMAL_5fFUNCTION(MKAbsyn__NO_5fPURITY));
      }
  | UNIONTYPE { ast = MKAbsyn__R_5fUNIONTYPE; }
  | OPERATOR (r=RECORD)?
          {
            ast = r ? MKAbsyn__R_5fOPERATOR_5fRECORD :
                  MKAbsyn__R_5fOPERATOR;
          }
  )
  ;


identifier returns [char* str] :
  ( id=IDENT | id=DER | id=CODE | id=EQUALITY | id=INITIAL ) { str = (char*)$id.text->chars; }
  ;

class_specifier returns [void* ast, void* name]
@init{ s1 = 0; s2 = 0; OM_PUSHZ5(mod, cmt, comp.ast, comp.ann, spec.ast); } :
    ( s1=identifier spec=class_specifier2
      {
        modelicaParserAssert($spec.s2 == NULL || !strcmp(s1,$spec.s2), "The identifier at start and end are different", class_specifier, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
        $ast = $spec.ast;
        $name = mmc_mk_scon(s1);
      }
    | EXTENDS s1=identifier (mod=class_modification)? cmt=string_comment comp=composition s2=END_IDENT
      {
        modelicaParserAssert(!strcmp(s1,(char*)$s2.text->chars), "The identifier at start and end are different", class_specifier, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
        $name = mmc_mk_scon(s1);
        $ast = MKAbsyn__CLASS_5fEXTENDS($name, or_nil(mod), mmc_mk_some_or_none(cmt), $comp.ast, listReverse($comp.ann));
      }
    )
    ;
    finally{ OM_POP(5); }

class_specifier2 returns [void* ast, const char *s2]
@init {
  $s2 = 0; gt = 0; rp = 0; OM_PUSHZ11(ids, cmtStr, cmt, c.ast, c.ann, na, attr, path.ast, cm, cs, ts.ast);
} :
(
  (lt=LESS ids=ident_list gt=GREATER)? cmtStr=string_comment c=composition id=END_IDENT
    {
      $s2 = (char*)$id.text->chars;
      if (lt != NULL) {
        modelicaParserAssert(metamodelica_enabled(),"Polymorphic classes are only available in MetaModelica", class_specifier2, $start->line, $start->charPosition+1, $gt->line, $gt->charPosition+2);
        $ast = MKAbsyn__PARTS(ids, mmc_mk_nil(), $c.ast, listReverse($c.ann), mmc_mk_some_or_none(cmtStr));
      } else {
        $ast = MKAbsyn__PARTS(mmc_mk_nil(), mmc_mk_nil(), $c.ast, listReverse($c.ann), mmc_mk_some_or_none(cmtStr));
      }
    }
| (lp = LPAR na=named_arguments rp=RPAR) cmtStr=string_comment c=composition id=END_IDENT
    {
      modelicaParserAssert(optimica_enabled(),"Class attributes are currently allowed only for Optimica. Use -g=Optimica.", class_specifier2, $start->line, $start->charPosition+1, $lp->line, $lp->charPosition+2);
      $ast = MKAbsyn__PARTS(mmc_mk_nil(), na, $c.ast, listReverse($c.ann), mmc_mk_some_or_none(cmtStr));
    }
| EQUALS attr=base_prefix path=type_specifier ( cm=class_modification )? cmt=comment
    {
      $ast = MKAbsyn__DERIVED($path.ast, attr, or_nil(cm), mmc_mk_some_or_none(cmt));
    }
| EQUALS cs=enumeration { $ast=cs; }
| EQUALS cs=pder { $ast=cs; }
| EQUALS cs=overloading { $ast=cs; }
| SUBTYPEOF ts=type_specifier
   {
     $ast = MKAbsyn__DERIVED(MKAbsyn__TCOMPLEX(MKAbsyn__IDENT(mmc_mk_scon("polymorphic")),mmc_mk_cons_typed(MKAbsyn_TypeSpec, $ts.ast, mmc_mk_nil()),mmc_mk_nil()),
                           MKAbsyn__ATTR(MMC_FALSE,MMC_FALSE,MKAbsyn__NON_5fPARALLEL,MKAbsyn__VAR,MKAbsyn__BIDIR,MKAbsyn__NONFIELD,mmc_mk_nil(), MMC_FALSE),mmc_mk_nil(),mmc_mk_none());
   }
)
;
finally{ OM_POP(11); }

pder returns [void* ast]
@init { OM_PUSHZ3(func, var_lst, cmt); } :
  DER LPAR func=name_path COMMA var_lst=ident_list RPAR cmt=comment
  {
    ast = MKAbsyn__PDER(func, var_lst, mmc_mk_some_or_none(cmt));
  }
  ;
  finally{ OM_POP(3); }

ident_list returns [void* ast]
@init { i = 0; OM_PUSHZ1(il); } :
  i=IDENT (COMMA il=ident_list)?
    {
      ast = mmc_mk_cons(token_to_scon(i), or_nil(il));
    }
  ;
  finally{ OM_POP(1); }


overloading returns [void* ast]
@init { OM_PUSHZ2(nl, cmt); } :
  OVERLOAD LPAR nl=name_list RPAR cmt=comment
    {
      ast = MKAbsyn__OVERLOAD(nl, mmc_mk_some_or_none(cmt));
    }
  ;
  finally{ OM_POP(2); }

base_prefix returns [void* ast]
@init { OM_PUSHZ7(tp.flow, tp.stream, tp.parallelism, tp.variability, tp.direction, tp.field, ast); } :
  tp=type_prefix { ast = MKAbsyn__ATTR(tp.flow, tp.stream, tp.parallelism, tp.variability, tp.direction, tp.field, mmc_mk_nil(), tp.isMode); }
  ;
  finally{ OM_POP(7); }

name_list returns [void* ast]
@init { OM_PUSHZ2(n, nl); } :
  n=name_path (COMMA nl=name_list)?
    {
      ast = mmc_mk_cons_typed(MKAbsyn_Path, n, or_nil(nl));
    }
  ;
  finally{ OM_POP(2); }

enumeration returns [void* ast]
@init { c = 0; OM_PUSHZ2(el, cmt); } :
  ENUMERATION LPAR (el=enum_list | c=COLON ) RPAR cmt=comment
    {
      if (c) {
        ast = MKAbsyn__ENUMERATION(MKAbsyn__ENUM_5fCOLON, mmc_mk_some_or_none(cmt));
      } else {
        ast = MKAbsyn__ENUMLITERALS(el);
        ast = MKAbsyn__ENUMERATION(ast, mmc_mk_some_or_none(cmt));
      }
    }
  ;
  finally{ OM_POP(2); }

enum_list returns [void* ast]
@init { OM_PUSHZ2(e, el); } :
  e=enumeration_literal ( COMMA el=enum_list )? { ast = mmc_mk_cons_typed(MKAbsyn_EnumLiteral, e, or_nil(el)); }
  ;
  finally{ OM_POP(2); }

enumeration_literal returns [void* ast]
@init { i1 = 0; OM_PUSHZ1(c1); } :
  i1=IDENT c1=comment { ast = token_to_scon(i1); ast = MKAbsyn__ENUMLITERAL(ast,mmc_mk_some_or_none(c1)); }
  ;
  finally{ OM_POP(1); }

composition returns [void* ast, void* ann]
@init { void *ann_local; OM_PUSHZ4(ann_local, el, els, a); ann_local = mmc_mk_nil(); } :
  el=element_list[&ann_local] els=composition2[&ann_local] (a=annotation SEMICOLON)?
  {
    $ast = mmc_mk_cons_typed(MKAbsyn_ClassPart, MKAbsyn__PUBLIC(el), els);
    $ann = a ? mmc_mk_cons_typed(MKAbsyn_Annotation, a, ann_local) : ann_local;
  }
  ;
  finally{ OM_POP(4); }

composition2 [ void **ann] returns [void* ast]
@init { OM_PUSHZ2(ext, el); } :
  ( ext=external_clause? { ast = or_nil(ext); }
  | ( el=public_element_list[ann]
    | el=protected_element_list[ann]
    | el=initial_equation_clause[ann]
    | el=initial_algorithm_clause[ann]
    | el=context_equation_clause[ann]
    | el=equation_clause[ann]
    | el=constraint_clause[ann]
    | el=algorithm_clause[ann]
    ) els=composition2[ann] {ast = mmc_mk_cons_typed(MKAbsyn_ClassPart, el, els); }
  )
  ;
  finally{ OM_POP(2); }

external_clause returns [void* ast]
@init { OM_PUSHZ4(retexp.ast, lang, expl, ann1); funcname = 0; } :
        EXTERNAL
        ( lang=language_specification )?
        ( ( retexp=component_reference EQUALS )?
          funcname=IDENT LPAR ( expl=expression_list )? RPAR )?
        ( ann1 = annotation )? SEMICOLON
          {
            lang = mmc_mk_some_or_none(lang);
            retexp.ast = mmc_mk_some_or_none(retexp.ast);
            ann1 = mmc_mk_some_or_none(ann1);
            ast = MKAbsyn__EXTERNALDECL(
                    funcname ? mmc_mk_some(token_to_scon(funcname)) : mmc_mk_none(),
                    lang,
                    retexp.ast,
                    or_nil(expl),
                    ann1);
            ast = mmc_mk_cons_typed(MKAbsyn_ClassPart, MKAbsyn__EXTERNAL(ast, mmc_mk_none()), mmc_mk_nil());
          }
        ;
        finally{ OM_POP(4); }

external_annotation returns [void* ast]
@init { OM_PUSHZ1(ann); } :
  ann=annotation SEMICOLON { ast = ann; }
  ;
  finally{ OM_POP(1); }

public_element_list [ void **ann] returns [void* ast]
@init { OM_PUSHZ1(es); } :
  PUBLIC es=element_list[ann] { ast = MKAbsyn__PUBLIC(es); }
  ;
  finally{ OM_POP(1); }

protected_element_list [ void **ann] returns [void* ast]
@init { OM_PUSHZ1(es); } :
  PROTECTED es=element_list[ann] {ast = MKAbsyn__PROTECTED(es); }
  ;
  finally{ OM_POP(1); }

language_specification returns [void* ast] :
  id=STRING {ast = token_to_scon(id);}
  ;

element_list [ void **ann] returns [void* ast]
@init {
  int first = 0, last = 0;
  OM_PUSHZ3(e.ast, ast, a);
  ast = mmc_mk_nil();
  last = LT(1)->getTokenIndex(LT(1));
  for (;omc_first_comment<last;omc_first_comment++) {
    pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,omc_first_comment);
    if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
      ast = mmc_mk_cons_typed(MKAbsyn_ElementItem, MKAbsyn__LEXER_5fCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),ast);
    }
  }
} :
  ((
     ( e=element {ast=mmc_mk_cons_typed(MKAbsyn_ElementItem, MKAbsyn__ELEMENTITEM(e.ast), ast);}
     | ( { ann && (ModelicaParser_langStd < 31 || 1) }? a=annotation {*ann = mmc_mk_cons_typed(MKAbsyn_Annotation, a, *ann);} )
     )
  ) SEMICOLON
    {
      last = LT(1)->getTokenIndex(LT(1));
      for (;omc_first_comment<last;omc_first_comment++) {
        pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,omc_first_comment);
        if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
          ast = mmc_mk_cons_typed(MKAbsyn_ElementItem, MKAbsyn__LEXER_5fCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)), ast);
        }
      }
    }
  )*
  {
    $ast = listReverseInPlace($ast);
    if (ann) {
      *ann = listReverseInPlace(*ann);
    }
  }
  ;
  finally{ OM_POP(3); }

element returns [void* ast]
@declarations { void *final = 0, *innerouter = 0; }
@init { f = 0; i = 0; o = 0; r = 0; void *redecl; OM_PUSHZ10(cc, $ast, cdef.ast, constr, final, innerouter, ic, ec, du, redecl); }
  :
    ic=import_clause { $ast = MKAbsyn__ELEMENT(MMC_FALSE,mmc_mk_none(),MKAbsyn__NOT_5fINNER_5fOUTER, ic, PARSER_INFO($start), mmc_mk_none()); }
  | ec=extends_clause { $ast = MKAbsyn__ELEMENT(MMC_FALSE,mmc_mk_none(),MKAbsyn__NOT_5fINNER_5fOUTER, ec, PARSER_INFO($start),mmc_mk_none()); }
  | du=defineunit_clause { $ast = du; }
  | (r=REDECLARE)? (f=FINAL)? (i=INNER)? (o=T_OUTER)? { final = mmc_mk_bcon(f); innerouter = make_inner_outer(i,o); }
    ( ( cdef=class_definition[f != NULL] | cc=component_clause )
        {
           redecl = r != NULL ? mmc_mk_some(make_redeclare_keywords(false,r != NULL)) : mmc_mk_none();
           if (!cc) {
             cdef.ast = MKAbsyn__CLASSDEF(MMC_FALSE, cdef.ast);
             $ast = MKAbsyn__ELEMENT(final, redecl,
                                  innerouter,
                                  cdef.ast,
                                  PARSER_INFO($start), mmc_mk_none());
           } else {
             $ast = MKAbsyn__ELEMENT(final, redecl, innerouter,
                                   cc, PARSER_INFO($start), mmc_mk_none());
          }
        }
    | (REPLACEABLE ( cdef=class_definition[f != NULL] | cc=component_clause ) constr=constraining_clause_comment? )
        {
           redecl = mmc_mk_some(make_redeclare_keywords(true,r != NULL));
           constr = mmc_mk_some_or_none(constr);
           if (cc) {
             $ast = MKAbsyn__ELEMENT(final, redecl, innerouter,
                                   cc, PARSER_INFO($start), constr);
           } else {
             cdef.ast = MKAbsyn__CLASSDEF(MMC_TRUE, cdef.ast);
             $ast = MKAbsyn__ELEMENT(final, redecl, innerouter,
                                   cdef.ast, PARSER_INFO($start), constr);
           }
        }
    )
  | conn=CONNECT
    {
       modelicaParserAssert(0, "Found the start of a connect equation but expected an element (are you missing the equation keyword?)", element, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
    }
  ;
  finally{ OM_POP(10); }

import_clause returns [void* ast]
@init { im = 0; OM_PUSHZ2(cmt, imp); } :
  im=IMPORT (imp=explicit_import_name | imp=implicit_import_name) cmt=comment
    {
      cmt = mmc_mk_some_or_none(cmt);
      ast = MKAbsyn__IMPORT(imp, cmt, PARSER_INFO($im));
    }
  ;
  finally{ OM_POP(2); }

defineunit_clause returns [void* ast]
@init { id = 0; OM_PUSHZ1(na); } :
  DEFINEUNIT id=IDENT (LPAR na=named_arguments RPAR)?
    {
      ast = MKAbsyn__DEFINEUNIT(token_to_scon(id),or_nil(na), PARSER_INFO($id));
    }
  ;
  finally{ OM_POP(1); }

explicit_import_name returns [void* ast]
@init { id = 0; OM_PUSHZ1(p); } :
  (id=IDENT|id=CODE) EQUALS p=name_path {ast = MKAbsyn__NAMED_5fIMPORT(token_to_scon(id),p); }
  ;
  finally{ OM_POP(1); }

implicit_import_name returns [void* ast]
@init { OM_PUSHZ2(np.lst, np.ast); np.unqual = 0; } :
  np=name_path_star
  {
    ast = np.lst ? MKAbsyn__GROUP_5fIMPORT(np.ast, np.lst) : np.unqual ? MKAbsyn__UNQUAL_5fIMPORT(np.ast) : MKAbsyn__QUAL_5fIMPORT(np.ast);
  }
  ;
  finally{ OM_POP(2); }

/*
 * 2.2.3 Extends
 */

// Note that this is a minor modification of the standard by
// allowing the comment.
extends_clause returns [void* ast]
@init { OM_PUSHZ3(path, mod, ann); } :
  EXTENDS path=name_path (mod=class_modification)? (ann=annotation)?
  {
    ast = MKAbsyn__EXTENDS(path,or_nil(mod),mmc_mk_some_or_none(ann));
  }
  ;
  finally{ OM_POP(3); }

constraining_clause_comment returns [void* ast]
@init { OM_PUSHZ2(constr, cmt); } :
  constr=constraining_clause cmt=comment { $ast = MKAbsyn__CONSTRAINCLASS(constr, mmc_mk_some_or_none(cmt)); }
  ;
  finally{ OM_POP(2); }

constraining_clause returns [void* ast]
@init { OM_PUSHZ2(np, mod); } :
    EXTENDS np=name_path  (mod=class_modification)? { ast = MKAbsyn__EXTENDS(np,or_nil(mod),mmc_mk_none()); }
  | CONSTRAINEDBY np=name_path (mod=class_modification)? { ast = MKAbsyn__EXTENDS(np,or_nil(mod),mmc_mk_none()); }
  ;
  finally{ OM_POP(2); }

/*
 * 2.2.4 Component clause
 */

component_clause returns [void* ast]
@declarations { void *arr = 0, *ar_option = 0; }
@init { OM_PUSHZ11(path.ast, clst, ast, arr, ar_option, tp.flow, tp.stream, tp.parallelism, tp.variability, tp.direction, tp.field); } :
  tp=type_prefix path=type_specifier clst=component_list
    {
      // Take the last (array subscripts) from type and move it to ATTR
      if (isPath($path.ast)) // is TPATH(path, arr)
      {
        /* Are these things OK? */
        ar_option = jl_data_ptr($path.ast)[1];
        jl_data_ptr($path.ast)[1] = jl_nothing;
        jl_gc_wb($path.ast, jl_nothing);
      }
      else if (isComplex($path.ast))
      {
        /* Are these things OK? */
        ar_option = jl_data_ptr($path.ast)[2];
        jl_data_ptr($path.ast)[2] = jl_nothing;
        jl_gc_wb($path.ast, jl_nothing);
      }
      else
      {
        fprintf(stderr, "component_clause error\n");
      }

      { /* adrpo - use the ANSI C standard */
        // no arr was set, inspect ar_option and fix it
        if (optionNone(ar_option))
        {
          arr = mmc_mk_nil();
        }
        else // is SOME(arr)
        {
          arr = jl_data_ptr(ar_option)[0];
        }
      }

      ast = MKAbsyn__COMPONENTS(MKAbsyn__ATTR(tp.flow, tp.stream, tp.parallelism, tp.variability, tp.direction, tp.field, arr, tp.isMode), $path.ast, clst);
    }
  ;
  finally{ OM_POP(11); }

type_prefix returns [void* flow, void* stream, void* parallelism, void* variability, void* direction, void* field, void *isMode]
@init { fl = 0; st = 0; srd = 0; glb = 0; di = 0; pa = 0; co = 0; in = 0; out = 0; fi = 0; nofi = 0; OM_PUSHZ7($flow, $stream, $parallelism, $variability, $direction, $field, $isMode); } :
  (fl=FLOW|st=STREAM)? (mo=MODE)? (srd=T_LOCAL|glb=T_GLOBAL)? (di=DISCRETE|pa=PARAMETER|co=CONSTANT)? in=T_INPUT? out=T_OUTPUT? (fi=FIELD|nofi=NONFIELD)?
    {
      $isMode= mmc_mk_bcon(mo);
      $flow = mmc_mk_bcon(fl);
      $stream = mmc_mk_bcon(st);
      $parallelism = srd ? MKAbsyn__PARLOCAL : glb ? MKAbsyn__PARGLOBAL : MKAbsyn__NON_5fPARALLEL;
      $variability = di ? MKAbsyn__DISCRETE : pa ? MKAbsyn__PARAM : co ? MKAbsyn__CONST : MKAbsyn__VAR;
      if (in && out) {
        modelicaParserAssert(metamodelica_enabled(),"Type prefix \"input output\" is not available in Modelica (use either input or output)", type_prefix, $in->line, $in->charPosition+1, $out->line, $out->charPosition+1);
        $direction = MKAbsyn__INPUT_5fOUTPUT;
      } else {
        $direction = in ? MKAbsyn__INPUT : out ? MKAbsyn__OUTPUT : MKAbsyn__BIDIR;
      }
      $field = fi ? MKAbsyn__FIELD : nofi ? MKAbsyn__NONFIELD : MKAbsyn__NONFIELD;
    }
  ;
  finally{ OM_POP(6); }

type_specifier returns [void* ast]
@init { OM_PUSHZ3(np, ts, as); } :
  np=name_path
  (lt=LESS ts=type_specifier_list gt=GREATER)? (as=array_subscripts)?
    {
      if (ts != NULL) {
        modelicaParserAssert(metamodelica_enabled(),"Algebraic data types are only available in MetaModelica", type_specifier, $start->line, $start->charPosition+1, $gt->line, $gt->charPosition+2);

        $ast = MKAbsyn__TCOMPLEX(np,ts,mmc_mk_some_or_none(as));
      } else {
        $ast = MKAbsyn__TPATH(np,mmc_mk_some_or_none(as));
      }
    }
  ;
  finally{ OM_POP(3); }

type_specifier_list returns [void* ast]
@init { OM_PUSHZ3($np1.ast, np2, ast); } :
  np1=type_specifier ( COMMA np2=type_specifier_list )? { ast = mmc_mk_cons_typed(MKAbsyn_TypeSpec, $np1.ast, or_nil(np2)); }
  ;
  finally{ OM_POP(3); }

component_list returns [void* ast]
@init { OM_PUSHZ2(c, cs); } :
  c=component_declaration (COMMA cs=component_list)? { ast = mmc_mk_cons_typed(MKAbsyn_ComponentItem, c, or_nil(cs)); }
  ;
  finally{ OM_POP(2); }

component_declaration returns [void* ast]
@init { OM_PUSHZ3(decl, cond, cmt); } :
  decl=declaration (cond=conditional_attribute)? cmt=comment
  {
    cond = mmc_mk_some_or_none(cond);
    cmt = mmc_mk_some_or_none(cmt);
    ast = MKAbsyn__COMPONENTITEM(decl, cond, cmt);
  }
  ;
  finally{ OM_POP(3); }

conditional_attribute returns [void* ast]
@init { OM_PUSHZ1(e.ast); } :
  IF e=expression[metamodelica_enabled()] { ast = e.ast; }
  ;
  finally{ OM_POP(1); }

declaration returns [void* ast]
@init { id = 0; OM_PUSHZ2(as, mod.ast); } :
  ( id=IDENT | id=OPERATOR ) (as=array_subscripts)? (mod=modification)?
    {
      mod.ast = mmc_mk_some_or_none($mod.ast);
      ast = MKAbsyn__COMPONENT(token_to_scon(id), or_nil(as), mod.ast);
    }
  ;
  finally{ OM_POP(2); }

/*
 * 2.2.5 Modification
 */

modification returns [void* ast]
@init { OM_PUSHZ2(e.ast, cm); eq = 0; } :
  ( cm=class_modification ( eq=EQUALS e=expression[metamodelica_enabled()] )?
  | eq=EQUALS e=expression[metamodelica_enabled()]
  | eq=ASSIGN e=expression[metamodelica_enabled()] {c_add_source_message(NULL,2, ErrorType_syntax, ErrorLevel_warning, ":= in modifiers has been deprecated",
              NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition+1,
              ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);}
  )
    {
      $ast = MKAbsyn__CLASSMOD(or_nil(cm), e.ast ? MKAbsyn__EQMOD(e.ast,PARSER_INFO($eq)) : MKAbsyn__NOMOD);
    }
  ;
  finally{ OM_POP(2); }

class_modification returns [void* ast]
@init { OM_PUSHZ2(as, ast); } :
  LPAR ( as=argument_list )? RPAR { ast = or_nil(as); }
  ;
  finally{ OM_POP(2); }

argument_list returns [void* ast]
@init { OM_PUSHZ3(a, as, ast); } :
  a=argument ( COMMA as=argument_list )?
  {
    if (!a)
    {
       fprintf(stderr, "crap!\n");
    }
    ast = mmc_mk_cons_typed(MKAbsyn_ElementArg, a, or_nil(as));
  }
  ;
  finally{ OM_POP(3); }

argument returns [void* ast]
@init { OM_PUSHZ2(em, er.ast); } :
  ( em=element_modification_or_replaceable { $ast = em; }
  | er=element_redeclaration { $ast = $er.ast; }
  )
  ;
  finally{ OM_POP(2); }

element_modification_or_replaceable returns [void* ast]
@init { OM_PUSHZ2(ast, em.ast); e = 0; f = 0; } :
    (e=EACH)? (f=FINAL)? ( em=element_modification[e ? MKAbsyn__EACH : MKAbsyn__NON_5fEACH, mmc_mk_bcon(f)] { ast = $em.ast; }
                         | er=element_replaceable[e != NULL,f != NULL,false] { ast = $er.ast; }
                         )
    ;
    finally{ OM_POP(2); }

element_modification [void *each, void *final] returns [void* ast]
@init { void *mod_tmp; OM_PUSHZ5(mod_tmp, $ast, $mod.ast, cmt, path); br = 0;} :
  path=name_path2 (br=LBRACK | ((mod=modification)? cmt=string_comment))
  {
    if (br) {
      ModelicaParser_lexerError = ANTLR3_TRUE;
      c_add_source_message(NULL, 2, ErrorType_syntax, ErrorLevel_error, "Subscripting modifiers is not allowed. Apply the modification on the whole identifier using an array-expression or an each-modifier.",
              NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition,
              ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
    }
    mod_tmp = mmc_mk_some_or_none($mod.ast);
    cmt = mmc_mk_some_or_none(cmt);
    $ast = MKAbsyn__MODIFICATION(final, each, path, mod_tmp, cmt, PARSER_INFO($start));
  }
  ;
  finally{ OM_POP(5); }

element_redeclaration returns [void* ast]
@init { void *redecl; OM_PUSHZ5($ast, er.ast, cc, cdef.ast, redecl); f = 0; e = 0; } :
  REDECLARE (e=EACH)? (f=FINAL)?
  ( (cdef=class_definition[f != NULL] | cc=component_clause1) | er=element_replaceable[e != NULL,f != NULL, true] )
     {
       if ($er.ast) {
         $ast = $er.ast;
       } else {
         $ast = $cc.ast ? $cc.ast : MKAbsyn__CLASSDEF(MMC_FALSE,$cdef.ast);
         redecl = make_redeclare_keywords(false,true);
         $ast = MKAbsyn__REDECLARATION(mmc_mk_bcon(f), redecl, e ? MKAbsyn__EACH : MKAbsyn__NON_5fEACH, $ast, mmc_mk_none(), PARSER_INFO($start));
       }
     }
  ;
  finally{ OM_POP(5); }

element_replaceable [int each, int final, int redeclare] returns [void* ast]
@init { void *redecl; OM_PUSHZ5($ast, e_spec, cd.ast, constr, redecl); } :
  REPLACEABLE ( cd=class_definition[final] | e_spec=component_clause1 ) constr=constraining_clause_comment?
  {
      e_spec = e_spec ? e_spec : MKAbsyn__CLASSDEF(MMC_TRUE, $cd.ast);
      constr = mmc_mk_some_or_none(constr);
      redecl = make_redeclare_keywords(true,redeclare);
      $ast = MKAbsyn__REDECLARATION(mmc_mk_bcon(final), redecl,
                                  each ? MKAbsyn__EACH : MKAbsyn__NON_5fEACH, e_spec,
                                  constr, PARSER_INFO($start));
  }
  ;
  finally{ OM_POP(5); }

component_clause1 returns [void* ast]
@init { OM_PUSHZ3(attr, ts.ast, comp_decl); } :
  attr=base_prefix ts=type_specifier comp_decl=component_declaration1
    {
      ast = MKAbsyn__COMPONENTS(attr, $ts.ast, mmc_mk_cons_typed(MKAbsyn_ComponentItem, comp_decl, mmc_mk_nil()));
    }
  ;
  finally{ OM_POP(3); }

component_declaration1 returns [void* ast]
@init { OM_PUSHZ2(decl, cmt); } :
  decl=declaration cmt=comment  { ast = MKAbsyn__COMPONENTITEM(decl, mmc_mk_none(), mmc_mk_some_or_none(cmt)); }
  ;
  finally{ OM_POP(2); }


/*
 * 2.2.6 Equations
 */








//Context Equation Section (builds)
context_equation_clause [ void **ann] returns [void* ast]
@init {OM_PUSHZ2(label,es);} :
EQUATION CONTEXT_ON label=identifier es=equation_annotation_list[ann] {
  ast = MKAbsyn__CONTEXTEQUATIONSECTIONS(__mmc_mk_cons(MKAbsyn__CONTEXTEQUATIONSECTION(mmc_mk_scon(label),es),mmc_mk_nil()));
}
   ;
  finally{ OM_POP(2); }



// Context List
// context_section_clause [ void **ann] returns [void* ast]
// @init {printf("match"); OM_PUSHZ1(cl.ast);} :
// CONTEXT_DEF cl=context_element_clause[ann]
//   {
//     jl_debug_println(cl);
//     ast = MKAbsyn__CONTEXTDEFINITIONSECTIONS(__mmc_mk_cons(MKAbsyn__CONTEXTDEFINITIONSECTION(cl.ast),mmc_mk_nil()));
//   }
//   ;
// finally{ OM_POP(1); }


// context_element_clause [ void **ann]  returns [void* ast]
// @init {OM_PUSHZ2(label,c.ast);} :
//   label=identifier CONTEXT_ON c=expression[metamodelica_enabled()] SEMICOLON
//   {
//     ast = MKAbsyn__CONTEXT(mmc_mk_scon(label),mmc_mk_cons_typed(MKAbsyn_Exp, c.ast, mmc_mk_nil()));
//   }
//   ;
// finally{ OM_POP(2); }






initial_equation_clause [ void **ann] returns [void* ast]
@init { OM_PUSHZ1(es); } :
  { LA(2)==EQUATION }?
  INITIAL EQUATION es=equation_annotation_list[ann] { ast = MKAbsyn__INITIALEQUATIONS(es); }
  ;
  finally{ OM_POP(1); }

equation_clause [ void **ann] returns [void* ast]
@init { OM_PUSHZ1(es); } :
  EQUATION es=equation_annotation_list[ann] { ast = MKAbsyn__EQUATIONS(es); }
  ;
  finally{ OM_POP(1); }

constraint_clause [ void **ann] returns [void* ast]
@init { OM_PUSHZ1(cs); } :
  CONSTRAINT cs=constraint_annotation_list[ann] { ast = MKAbsyn__CONSTRAINTS(cs); }
  ;
  finally{ OM_POP(1); }

equation_annotation_list [ void **ann] returns [void* ast]
@init {
  int last, haveEq;
  last = LT(1)->getTokenIndex(LT(1));
  OM_PUSHZ3(ea, eq.ast, ast);
  ast = mmc_mk_nil();
  for (;omc_first_comment<last;omc_first_comment++) {
    pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,omc_first_comment);
    if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
      ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, MKAbsyn__EQUATIONITEMCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),ast);
    }
  }
} :
  (
  { LA(1) != END_IDENT && LA(1) != CONSTRAINT && LA(1) != EQUATION && LA(1) != T_ALGORITHM && LA(1)!=INITIAL && LA(1) != PROTECTED && LA(1) != PUBLIC }? =>
  ( eq=equation SEMICOLON { ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, eq.ast, ast); }
  | ea=annotation SEMICOLON {*ann = mmc_mk_cons_typed(MKAbsyn_Annotation, ea, *ann);}
  )
    {
      last = LT(1)->getTokenIndex(LT(1));
      for (;omc_first_comment<last;omc_first_comment++) {
        pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,omc_first_comment);
        if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
          ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, MKAbsyn__EQUATIONITEMCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),ast);
        }
      }
    }
  )*
    {
      ast = listReverseInPlace(ast);
      if (ann) {
      *ann = listReverseInPlace(*ann);
      }
    }
  ;
  finally{ OM_POP(3); }

constraint_annotation_list [ void **ann] returns [void* ast]
@init { OM_PUSHZ3(co, c, cs); }
:
  { LA(1) == END_IDENT || LA(1) == CONSTRAINT || LA(1) == EQUATION || LA(1) ==
T_ALGORITHM || LA(1)==INITIAL || LA(1) == PROTECTED || LA(1) == PUBLIC }?
    { ast = mmc_mk_nil(); }
  |
  ( co=constraint SEMICOLON { c = co; }
  | c=annotation SEMICOLON { *ann = mmc_mk_cons_typed(MKAbsyn_Annotation, c, *ann); }
  ) cs=constraint_annotation_list[ann] { ast = c ? mmc_mk_cons_typed(MKAbsyn_Exp, c, cs) : cs; }
  ;
  finally{ OM_POP(3); }


algorithm_clause [ void **ann] returns [void* ast]
@init{ OM_PUSHZ1(as.ast); } :
  T_ALGORITHM as=algorithm_annotation_list[ann,0] { ast = MKAbsyn__ALGORITHMS(as.ast); }
  ;
  finally{ OM_POP(1); }

initial_algorithm_clause [ void **ann] returns [void* ast]
@init{ OM_PUSHZ1(as.ast); } :
  { LA(2)==T_ALGORITHM }?
  INITIAL T_ALGORITHM as=algorithm_annotation_list[ann,0] { ast = MKAbsyn__INITIALALGORITHMS(as.ast); }
  ;
  finally{ OM_POP(1); }

algorithm_annotation_list [ void **ann, int matchCase] returns [void* ast]
@init {
  int last,isalg = 0;
  OM_PUSHZ3(al.ast, $ast, a);
  $ast = mmc_mk_nil();
  last = LT(1)->getTokenIndex(LT(1));
  for (;omc_first_comment<last;omc_first_comment++) {
    pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,omc_first_comment);
    if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
      $ast = mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, MKAbsyn__ALGORITHMITEMCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),$ast);
    }
  }
} :
  (
    { matchCase ? LA(1) != THEN : (LA(1) != END_IDENT && LA(1) != EQUATION && LA(1) != T_ALGORITHM && LA(1)!=INITIAL && LA(1) != PROTECTED && LA(1) != PUBLIC) }?=>
  ( al=algorithm SEMICOLON { $ast = mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, al.ast,$ast); }
  | a=annotation SEMICOLON {
      if (ann) {
        *ann = mmc_mk_cons_typed(MKAbsyn_Annotation, a, *ann);
      } else {
        ModelicaParser_lexerError = ANTLR3_TRUE;
        c_add_source_message(NULL, 2, ErrorType_syntax, ErrorLevel_error, "Annotations are not allowed in an algorithm list.",
              NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition,
              ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
      }
    }
  )
  {
    last = LT(1)->getTokenIndex(LT(1));
    for (;omc_first_comment<last;omc_first_comment++) {
      pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,omc_first_comment);
      if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
        $ast = mmc_mk_cons_typed(MKAbsyn_AlgorithmItem,MKAbsyn__ALGORITHMITEMCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),$ast);
      }
    }
  }
  )*
  {
    $ast = listReverseInPlace($ast);
    if (ann) {
    *ann = listReverseInPlace(*ann);
    }
  }
  ;
  finally{ OM_POP(3); }

equation returns [void* ast]
@init { OM_PUSHZ6(cmt, e, e1.ast, e2.ast, eq.ast, ee.ast); } :
  ( ee=equality_or_noretcall_equation { e = ee.ast; }
  | e=conditional_equation_e
  | e=for_clause_e
  | e=parfor_clause_e
  | e=connect_clause
  | e=when_clause_e
  | FAILURE LPAR eq=equation RPAR { e = MKAbsyn__EQ_5fFAILURE(eq.ast); }
  | EQUALITY LPAR e1=expression[metamodelica_enabled()] EQUALS e2=expression[metamodelica_enabled()] RPAR
    {
      e = MKAbsyn__EQ_5fNORETCALL(
        MKAbsyn__CREF_5fIDENT(mmc_mk_scon("equality"),mmc_mk_nil()),
        MKAbsyn__FUNCTIONARGS(mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, mmc_mk_cons_typed(MKAbsyn_Exp, e2.ast, mmc_mk_nil())), mmc_mk_nil()));
    }
  )
  cmt=comment
  {
    cmt = mmc_mk_some_or_none(cmt);
    $ast = MKAbsyn__EQUATIONITEM(e, cmt, PARSER_INFO($start));
  }
  ;
  finally{ OM_POP(6); }

constraint returns [void* ast]
@init { OM_PUSHZ5(a, al.ast, e1.ast, e2.ast, cmt); } :
  ( a = simple_expr
  | a=conditional_equation_a
  | a=for_clause_a
  | a=parfor_clause_a
  | a=while_clause
  | a=when_clause_a
  | BREAK { a = MKAbsyn__ALG_5fBREAK; }
  | RETURN { a = MKAbsyn__ALG_5fRETURN; }
  | CONTINUE { a = MKAbsyn__ALG_5fCONTINUE; }
  | FAILURE LPAR al=algorithm RPAR { a = MKAbsyn__ALG_5fFAILURE(mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, al.ast, mmc_mk_nil())); }
  | EQUALITY LPAR e1=expression[metamodelica_enabled()] ASSIGN e2=expression[metamodelica_enabled()] RPAR
    {
      a = MKAbsyn__ALG_5fNORETCALL(
        MKAbsyn__CREF_5fIDENT(mmc_mk_scon("equality"),mmc_mk_nil()),
        MKAbsyn__FUNCTIONARGS(mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, mmc_mk_cons_typed(MKAbsyn_Exp, e2.ast, mmc_mk_nil())), mmc_mk_nil()));
    }
  )
  cmt=comment
  {
    $ast = a;
  }
  ;
  finally{ OM_POP(5); }


algorithm returns [void* ast]
@init { OM_PUSHZ6(aa.ast, al.ast, a, e1.ast, e2.ast, cmt); } :
  ( aa=assign_clause_a { a = aa.ast; }
  | a=conditional_equation_a
  | a=for_clause_a
  | a=parfor_clause_a
  | a=while_clause
  | a=try_clause
  | a=when_clause_a
  | BREAK { a = MKAbsyn__ALG_5fBREAK; }
  | RETURN { a = MKAbsyn__ALG_5fRETURN; }
  | CONTINUE { a = MKAbsyn__ALG_5fCONTINUE; }
  | FAILURE LPAR al=algorithm RPAR { a = MKAbsyn__ALG_5fFAILURE(mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, al.ast, mmc_mk_nil())); }
  | EQUALITY LPAR e1=expression[metamodelica_enabled()] ASSIGN e2=expression[metamodelica_enabled()] RPAR
    {
      a = MKAbsyn__CREF_5fIDENT(mmc_mk_scon("equality"),mmc_mk_nil());
      a = MKAbsyn__ALG_5fNORETCALL(
        a,
        MKAbsyn__FUNCTIONARGS(mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast,mmc_mk_cons_typed(MKAbsyn_Exp, e2.ast, mmc_mk_nil())),
        mmc_mk_nil()));
    }
  )
  cmt=comment
  {
    cmt = mmc_mk_some_or_none(cmt);
    $ast = MKAbsyn__ALGORITHMITEM(a, cmt, PARSER_INFO($start));
  }
  ;
  finally{ OM_POP(6); }

assign_clause_a returns [void* ast]
@declarations { char *s1 = 0; }
@init { OM_PUSHZ2(e1, e2.ast); eq = 0; } :
  /* MetaModelica allows pattern matching on arbitrary expressions in algorithm sections... */
  e1=simple_expression
    ( (ASSIGN|eq=EQUALS) e2=expression[metamodelica_enabled()]
      {
        modelicaParserAssert(eq == 0,"Algorithms can not contain equations ('='), use assignments (':=') instead", assign_clause_a, $eq->line, $eq->charPosition+1, $eq->line, $eq->charPosition+2);
        {
          int looks_like_cref = isCref(e1);
          int looks_like_call = (isTuple(e1) && isCall(e2.ast));
          int looks_like_der_cr = !looks_like_cref && !looks_like_call && omc_AbsynUtil_isDerCref(ModelicaParser_threadData, e1);
          modelicaParserAssert(eq != 0 || metamodelica_enabled() || looks_like_cref || looks_like_call || looks_like_der_cr,
              "Modelica assignment statements are either on the form 'component_reference := expression' or '( output_expression_list ) := function_call'",
              assign_clause_a, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
          if (looks_like_der_cr && !metamodelica_enabled()) {
            c_add_source_message(NULL,2, ErrorType_syntax, ErrorLevel_warning, "der(cr) := exp is not legal Modelica code. OpenModelica accepts it for interoperability with non-standards-compliant Modelica tools. There is no way to suppress this warning.",
              NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition+1,
              ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
          }
        }
        $ast = MKAbsyn__ALG_5fASSIGN(e1,e2.ast);
      }
    |
      {
        modelicaParserAssert(isCall(e1), "Only function call expressions may stand alone in an algorithm section",
                             assign_clause_a, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
        { /* uselsess block for ANSI C crap */
          $ast = MKAbsyn__ALG_5fNORETCALL(jl_data_ptr(e1)[0],jl_data_ptr(e1)[1]);
        }
      }
    )
  ;
  finally{ OM_POP(2); }

equality_or_noretcall_equation returns [void* ast]
@init { OM_PUSHZ3(e1, e2.ast, cr.ast); ass = 0; } :
  e1=simple_expression
    (  (EQUALS | ass=ASSIGN) e2=expression[metamodelica_enabled()] (INDOMAIN cr=component_reference2)?
      {
        modelicaParserAssert(ass==0,"Equations can not contain assignments (':='), use equality ('=') instead", equality_or_noretcall_equation, $ass->line, $ass->charPosition+1, $ass->line, $ass->charPosition+2);
        if (cr.ast != 0) {
                $ast = MKAbsyn__EQ_5fPDE(e1,e2.ast,cr.ast);
        } else {
                $ast = MKAbsyn__EQ_5fEQUALS(e1,e2.ast);
        }
      }
    | {LA(1) != EQUALS && LA(1) != ASSIGN}? /* It has to be a CALL */
       {
         modelicaParserAssert(isCall(e1),"A singleton expression in an equation section is required to be a function call", equality_or_noretcall_equation, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
         {
           $ast = MKAbsyn__EQ_5fNORETCALL(jl_data_ptr(e1)[0],jl_data_ptr(e1)[1]);
         }
       }
    )
  ;
  finally{ OM_POP(3); }

conditional_equation_e returns [void* ast]
@init { i = 0; OM_PUSHZ4(e.ast, then_b, else_b, else_if_b); } :
  IF e=expression[metamodelica_enabled()] THEN then_b=equation_list else_if_b=equation_elseif_list? ( ELSE else_b=equation_list )? (i=END_IF|t=END_IDENT|t=END_FOR|t=END_WHEN)
    {
      modelicaParserAssert(i,else_b ? "Expected 'end if'; did you use a nested 'else if' instead of 'elseif'?" : "Expected 'end if'",conditional_equation_e,t->line, t->charPosition+1, LT(1)->line, LT(1)->charPosition+1);
      ast = MKAbsyn__EQ_5fIF(e.ast, then_b, or_nil(else_if_b), or_nil(else_b));
    }
  ;
  finally{ OM_POP(4); }

conditional_equation_a returns [void* ast]
@init { i = 0; OM_PUSHZ4(e.ast, then_b, else_b, else_if_b); } :
  IF e=expression[metamodelica_enabled()] THEN then_b=algorithm_list else_if_b=algorithm_elseif_list? ( ELSE else_b=algorithm_list )? (i=END_IF|t=END_IDENT|t=END_FOR|t=END_WHEN|t=END_WHILE)
  {
    modelicaParserAssert(i,else_b ? "Expected 'end if'; did you use a nested 'else if' instead of 'elseif'?" : "Expected 'end if'",conditional_equation_a,t->line, t->charPosition+1, LT(1)->line, LT(1)->charPosition+1);
    ast = MKAbsyn__ALG_5fIF(e.ast, then_b, or_nil(else_if_b), or_nil(else_b));
  }
  ;
  finally{ OM_POP(4); }

for_clause_e returns [void* ast]
@init { OM_PUSHZ2(is, es); } :
  FOR is=for_indices LOOP es=equation_list END_FOR { ast = MKAbsyn__EQ_5fFOR(is,es); }
  ;
  finally{ OM_POP(2); }

for_clause_a returns [void* ast]
@init { OM_PUSHZ2(is, as); } :
  FOR is=for_indices LOOP as=algorithm_list END_FOR { ast = MKAbsyn__ALG_5fFOR(is,as); }
  ;
  finally{ OM_POP(2); }

parfor_clause_e returns [void* ast]
@init { OM_PUSHZ2(is, es); } :
  PARFOR is=for_indices LOOP es=equation_list END_PARFOR { ast = MKAbsyn__EQ_5fFOR(is, es); }
  ;
  finally{ OM_POP(2); }

parfor_clause_a returns [void* ast]
@init { OM_PUSHZ2(is, as); } :
  PARFOR is=for_indices LOOP as=algorithm_list END_PARFOR { ast = MKAbsyn__ALG_5fPARFOR(is, as); }
  ;
  finally{ OM_POP(2); }

while_clause returns [void* ast]
@init { OM_PUSHZ2(e.ast, as); } :
  WHILE e=expression[metamodelica_enabled()] LOOP as=algorithm_list END_WHILE { ast = MKAbsyn__ALG_5fWHILE(e.ast, as); }
  ;
  finally{ OM_POP(2); }

try_clause returns [void* ast]
@init { OM_PUSHZ2(as1, as2); } :
  TRY as1=algorithm_list ELSE as2=algorithm_list END_TRY { ast = MKAbsyn__ALG_5fTRY(as1,as2); }
  ;
  finally{ OM_POP(2); }

when_clause_e returns [void* ast]
@init{ OM_PUSHZ3(e.ast, body, es); } :
  WHEN e=expression[metamodelica_enabled()] THEN body=equation_list es=else_when_e_list? END_WHEN
    {
      ast = MKAbsyn__EQ_5fWHEN_5fE(e.ast,body,or_nil(es));
    }
  ;
  finally{ OM_POP(3); }

else_when_e_list returns [void* ast]
@init{ OM_PUSHZ2(es, e); } :
  e=else_when_e es=else_when_e_list? { ast = mmc_mk_cons(e, or_nil(es)); /* TODO: This will need some casting to make sure e is always MKAbsyn.Exp */ }
  ;
  finally{ OM_POP(2); }

else_when_e returns [void* ast]
@init{ OM_PUSHZ2(e.ast, es); } :
  ELSEWHEN e=expression[metamodelica_enabled()] THEN es=equation_list { ast = mmc_mk_tuple2(e.ast,es); }
  ;
  finally{ OM_POP(2); }

when_clause_a returns [void* ast]
@init{ OM_PUSHZ3(e.ast, body, es); } :
  WHEN e=expression[metamodelica_enabled()] THEN body=algorithm_list es=else_when_a_list? END_WHEN
    {
      ast = MKAbsyn__ALG_5fWHEN_5fA(e.ast,body,or_nil(es));
    }
  ;
  finally{ OM_POP(3); }

else_when_a_list returns [void* ast]
@init{ OM_PUSHZ2(e, es); } :
  e=else_when_a es=else_when_a_list? { ast = mmc_mk_cons(e,or_nil(es)); /* TODO: This will need some casting to make sure e is always MKAbsyn.Exp */ }
  ;
  finally{ OM_POP(2); }

else_when_a returns [void* ast]
@init{ OM_PUSHZ2(e.ast, as); } :
  ELSEWHEN e=expression[metamodelica_enabled()] THEN as=algorithm_list { ast = mmc_mk_tuple2(e.ast,as); }
  ;
  finally{ OM_POP(2); }

equation_elseif_list returns [void* ast]
@init{ OM_PUSHZ2(e, es); } :
  e=equation_elseif es=equation_elseif_list? { ast = mmc_mk_cons(e,or_nil(es)); /* TODO: This will need some casting to make sure e is always MKAbsyn.Exp */ }
  ;
  finally{ OM_POP(2); }

equation_elseif returns [void* ast]
@init{ OM_PUSHZ2(e.ast, es); } :
  ELSEIF e=expression[metamodelica_enabled()] THEN es=equation_list { ast = mmc_mk_tuple2(e.ast, es); }
  ;
  finally{ OM_POP(2); }

algorithm_elseif_list returns [void* ast]
@init{ OM_PUSHZ2(a, as); } :
  a=algorithm_elseif as=algorithm_elseif_list? { ast = mmc_mk_cons(a,or_nil(as)); /* TODO: This will need some casting to make sure e is always MKAbsyn.Exp */ }
  ;
  finally{ OM_POP(2); }

algorithm_elseif returns [void* ast]
@init{ OM_PUSHZ2(e.ast, as); } :
  ELSEIF e=expression[metamodelica_enabled()] THEN as=algorithm_list { ast = mmc_mk_tuple2(e.ast,as); }
  ;
  finally{ OM_POP(2); }

equation_list_then returns [void* ast]
@init{ OM_PUSHZ2(e.ast, es); } :
    { LA(1) == THEN }? { ast = mmc_mk_nil(); }
  | (e=equation SEMICOLON es=equation_list_then) { ast = mmc_mk_cons_typed(MKAbsyn_Equation, e.ast, es); }
  ;
  finally{ OM_POP(2); }

equation_list returns [void* ast]
@init {
  OM_PUSHZ3(ast, e.ast, es);
  int first = 0, last = 0;
  first = omc_first_comment;
  last = LT(1)->getTokenIndex(LT(1));
  omc_first_comment = last;
} :
  {LA(1) != END_IDENT || LA(1) != END_IF || LA(1) != END_WHEN || LA(1) != END_FOR}?
    {
      ast = mmc_mk_nil();
      for (;first<last;last--) {
        pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,last-1);
        if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
          ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, MKAbsyn__EQUATIONITEMCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),ast);
        }
      }
    }
  |
  ( e=equation SEMICOLON es=equation_list ) {
    ast = es;
    ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, e.ast,ast);
    for (;first<last;last--) {
      pANTLR3_COMMON_TOKEN tok = INPUT->get(INPUT,last-1);
      if (tok->getChannel(tok) == HIDDEN && (tok->type == LINE_COMMENT || tok->type == ML_COMMENT)) {
        ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, MKAbsyn__EQUATIONITEMCOMMENT(mmc_mk_scon((char*)tok->getText(tok)->chars)),ast);
      }
    }
  }
  ;
  finally{ OM_POP(3); }

algorithm_list returns [void* ast]
@init { OM_PUSHZ2(a.ast, as); } :
  {LA(1) != END_IDENT || LA(1) != END_IF || LA(1) != END_WHEN || LA(1) != END_FOR || LA(1) != END_WHILE}?
    { ast = mmc_mk_nil(); }
  | a=algorithm SEMICOLON as=algorithm_list { ast = mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, a.ast, as); }
  ;
  finally{ OM_POP(2); }

connect_clause returns [void* ast]
@init{ OM_PUSHZ2(cr1.ast, cr2.ast); } :
  CONNECT LPAR cr1=component_reference COMMA cr2=component_reference RPAR
  {
    ast = MKAbsyn__EQ_5fCONNECT(cr1.ast,cr2.ast);
  }
  ;
  finally{ OM_POP(2); }

/* adrpo: 2010-10-11, replaced commented-out part with the rule above
                      which is conform to the grammar in the Modelica specification!
connect_clause returns [void* ast]
@init{ OM_PUSHZ2(cr1, cr2); } :
  CONNECT LPAR cr1=connector_ref COMMA cr2=connector_ref RPAR { ast = MKAbsyn__EQ_5fCONNECT(cr1,cr2); }
  ;
  finally{ OM_POP(2); }

connector_ref returns [void* ast]
@init{ OM_PUSHZ2(as, cr2); } :
  id=IDENT ( as=array_subscripts )? ( DOT cr2=connector_ref_2 )?
    {
      if (cr2)
        ast = MKAbsyn__CREF_5fQUAL(token_to_scon(id),or_nil(as),cr2);
      else
        ast = MKAbsyn__CREF_5fIDENT(token_to_scon(id),or_nil(as));
    }
  ;
  finally{ OM_POP(2); }

connector_ref_2 returns [void* ast]
@init{ id = 0; OM_PUSHZ1(as); } :
  id=IDENT ( as=array_subscripts )? { ast = MKAbsyn__CREF_5fIDENT(token_to_scon(id),or_nil(as)); }
  ;
  finally{ OM_POP(1); }

*/

/*
 * 2.2.7 Expressions
 */
expression[int allowPartEvalFunc] returns [void* ast]
@init { OM_PUSHZ1(e); } :
  ( e=if_expression { $ast = e; }
  | e=simple_expression { $ast = e; }
  | e=code_expression { $ast = e; }
  | e=match_expression { $ast = e; }
  | e=part_eval_function_expression
    {
      if (!allowPartEvalFunc) {
        c_add_source_message(NULL,2,ErrorType_syntax, ErrorLevel_error, "Function partial application expressions are only allowed as inputs to functions.", NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition+1, ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
                ModelicaParser_lexerError = ANTLR3_TRUE;
      }
      $ast = e;
    }
  )
  ;
  finally{ OM_POP(1); }

part_eval_function_expression returns [void* ast]
@init { OM_PUSHZ2(cr.ast, args); } :
  FUNCTION cr=component_reference LPAR (args=named_arguments)? RPAR
  {
    ast = MKAbsyn__PARTEVALFUNCTION(cr.ast, MKAbsyn__FUNCTIONARGS(mmc_mk_nil(), or_nil(args)));
  }
  ;
  finally{ OM_POP(2); }

if_expression returns [void* ast]
@init{ OM_PUSHZ4(cond.ast, e1.ast, es, e2.ast); } :
  IF cond=expression[metamodelica_enabled()] THEN e1=expression[metamodelica_enabled()] es=elseif_expression_list? ELSE e2=expression[metamodelica_enabled()]
  {
    ast = MKAbsyn__IFEXP(cond.ast,e1.ast,e2.ast,or_nil(es));
  }
  ;
  finally{ OM_POP(4); }

elseif_expression_list returns [void* ast]
@init{ OM_PUSHZ2(e, es); } :
  e=elseif_expression es=elseif_expression_list? { ast = mmc_mk_cons(e,or_nil(es)); /* TODO: Need the tuple to have MKAbsyn.Exp */ }
  ;
  finally{ OM_POP(2); }

elseif_expression returns [void* ast]
@init { OM_PUSHZ2(e1.ast, e2.ast); } :
  ELSEIF e1=expression[metamodelica_enabled()] THEN e2=expression[metamodelica_enabled()] { ast = mmc_mk_tuple2(e1.ast,e2.ast); }
  ;
  finally{ OM_POP(2); }

for_indices returns [void* ast]
@init{ OM_PUSHZ2(i, is); } :
  i=for_index (COMMA is=for_indices)? { ast = mmc_mk_cons_typed(MKAbsyn_ForIterator, i, or_nil(is)); }
  ;
  finally{ OM_POP(2); }

for_index returns [void* ast]
@init{ i = 0; OM_PUSHZ2(e.ast, guard.ast); } :
  (i=IDENT (((IF|GUARD) guard=expression[metamodelica_enabled()])? T_IN e=expression[metamodelica_enabled()])?
   {
     guard.ast = mmc_mk_some_or_none(guard.ast);
     e.ast = mmc_mk_some_or_none(e.ast);
     ast = MKAbsyn__ITERATOR(token_to_scon(i),guard.ast,e.ast);
   }
  )
  ;
  finally{ OM_POP(2); }

simple_expression returns [void* ast]
@init{ OM_PUSHZ4(e, e1, e2, ast); i = 0; } :
    e1=simple_expr (COLONCOLON e2=simple_expression)?
    {
      if (e2)
        ast = MKAbsyn__CONS(e1, e2);
      else
        ast = e1;
    }
  | i=IDENT AS e=simple_expression
    {
      ast = MKAbsyn__AS(token_to_scon(i),e);
    }
  ;
  finally{ OM_POP(4); }

simple_expr returns [void* ast]
@init{ OM_PUSHZ3(e1, e2, e3); } :
  e1=logical_expression ( COLON e2=logical_expression ( COLON e3=logical_expression )? )?
    {
      if (e3)
        ast = MKAbsyn__RANGE(e1,mmc_mk_some(e2),e3);
      else if (e2)
        ast = MKAbsyn__RANGE(e1,mmc_mk_none(),e2);
      else
        ast = e1;
    }
  ;
  finally{ OM_POP(3); }

logical_expression returns [void* ast]
@init{ OM_PUSHZ3(e1, e2, ast); } :
  e1=logical_term { ast = e1; } ( T_OR e2=logical_term { ast = MKAbsyn__LBINARY(ast,MKAbsyn__OR,e2); } )*
  ;
  finally{ OM_POP(3); }

logical_term returns [void* ast]
@init{ OM_PUSHZ3(e1, e2, ast); } :
  e1=logical_factor { ast = e1; } ( T_AND e2=logical_factor { ast = MKAbsyn__LBINARY(ast,MKAbsyn__AND,e2); } )*
  ;
  finally{ OM_POP(3); }

logical_factor returns [void* ast]
@init{ n = 0; OM_PUSHZ1(e); } :
  ( n=T_NOT )? e=relation { ast = n ? MKAbsyn__LUNARY(MKAbsyn__NOT, e) : e; }
  ;
  finally{ OM_POP(1); }

relation returns [void* ast]
@declarations { void* op = NULL; }
@init { OM_PUSHZ4(e1, e2, op, ast); } :
  e1=arithmetic_expression
  ( ( LESS {op = MKAbsyn__LESS;} | LESSEQ {op = MKAbsyn__LESSEQ;}
    | GREATER {op = MKAbsyn__GREATER;} | GREATEREQ {op = MKAbsyn__GREATEREQ;}
    | EQEQ {op = MKAbsyn__EQUAL;} | LESSGT {op = MKAbsyn__NEQUAL;}
    ) e2=arithmetic_expression )?
    {
      ast = e2 ? MKAbsyn__RELATION(e1,op,e2) : e1;
    }
  ;
  finally{ OM_POP(4); }

arithmetic_expression returns [void* ast]
@declarations { void* op = NULL; }
@init { OM_PUSHZ4(e1, e2, op, ast); } :
  e1=unary_arithmetic_expression { ast = e1; }
    ( ( PLUS {op=MKAbsyn__ADD;} | MINUS {op=MKAbsyn__SUB;} | PLUS_EW {op=MKAbsyn__ADD_5fEW;} | MINUS_EW {op=MKAbsyn__SUB_5fEW;}
      ) e2=term { ast = MKAbsyn__BINARY(ast,op,e2); }
    )*
  ;
  finally{ OM_POP(4); }

unary_arithmetic_expression returns [void* ast]
@init { OM_PUSHZ2(t, ast); } :
  ( PLUS t=term     { ast = MKAbsyn__UNARY(MKAbsyn__UPLUS,t); }
  | MINUS t=term    { ast = MKAbsyn__UNARY(MKAbsyn__UMINUS,t); }
  | PLUS_EW t=term  { ast = MKAbsyn__UNARY(MKAbsyn__UPLUS_5fEW,t); }
  | MINUS_EW t=term { ast = MKAbsyn__UNARY(MKAbsyn__UMINUS_5fEW,t); }
  | t=term          { ast = t; }
  )
  ;
  finally{ OM_POP(2); }

term returns [void* ast]
@declarations { void* op = NULL; }
@init { OM_PUSHZ4(e1, e2, op, ast); } :
  e1=factor { ast = e1; }
    (
      ( STAR {op=MKAbsyn__MUL;} | SLASH {op=MKAbsyn__DIV;} | STAR_EW {op=MKAbsyn__MUL_5fEW;} | SLASH_EW {op=MKAbsyn__DIV_5fEW;} )
      e2=factor { ast = MKAbsyn__BINARY(ast,op,e2); }
    )*
  ;
  finally{ OM_POP(4); }

factor returns [void* ast]
@init{ OM_PUSHZ2(e1.ast, e2.ast); pw = 0; } :
  e1=primary ( ( pw=POWER | pw=POWER_EW ) e2=primary )?
    {
      ast = pw ? MKAbsyn__BINARY(e1.ast, $pw.type == POWER ? MKAbsyn__POW : MKAbsyn__POW_5fEW, e2.ast) : e1.ast;
    }
  ;
  finally{ OM_POP(2); }

primary returns [void* ast]
@declarations { int tupleExpressionIsTuple = 0; }
@init { v = 0; for_or_el.isFor = 0; OM_PUSHZ3(ptr.ast, el, for_or_el.ast) } :
  ( v=UNSIGNED_INTEGER
    {
      char* chars = (char*)$v.text->chars;
      char* endptr;
      const char* args[2] = {NULL};
      int l = 0;

      errno = 0;
      l = strtol(chars,&endptr,10);

      $ast = MKAbsyn__INTEGER(mmc_mk_icon(l));
    }
  | v=UNSIGNED_REAL
    {
      char* chars = (char*)$v.text->chars;
      char *endptr;
      errno = 0;
      double d = strtod(chars,&endptr);
      if (!(*endptr == 0 && errno==0)) {
        c_add_source_message(NULL,2,ErrorType_syntax, ErrorLevel_error, "\%s cannot be represented by a double on this machine", (const char **)&chars, 1, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition+1, ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
        ModelicaParser_lexerError = ANTLR3_TRUE;
      }
      $ast = MKAbsyn__REAL(mmc_mk_scon(chars));
    }
  | v=STRING           { $ast = MKAbsyn__STRING(mmc_mk_scon((char*)$v.text->chars)); }
  | T_FALSE            { $ast = MKAbsyn__BOOL(MMC_FALSE); }
  | T_TRUE             { $ast = MKAbsyn__BOOL(MMC_TRUE); }
  | ptr=component_reference__function_call { $ast = ptr.ast; }
  | DER el=function_call { $ast = MKAbsyn__CALL(MKAbsyn__CREF_5fIDENT(mmc_mk_scon("der"), mmc_mk_nil()),el,mmc_mk_nil()); }
  | LPAR el=output_expression_list[&tupleExpressionIsTuple]
    {
      $ast = tupleExpressionIsTuple ? MKAbsyn__TUPLE(el) : el;
    }
  | LBRACK el=matrix_expression_list RBRACK { $ast = MKAbsyn__MATRIX(el); }
  | LBRACE for_or_el=for_or_expression_list RBRACE
    {
      if (!for_or_el.isFor) {
        modelicaParserAssert(
          isNotNil(for_or_el.ast) ||
          metamodelica_enabled() ||
          parse_expression_enabled(), /* allow {} in mos scripts */
          "Empty array constructors are not valid in Modelica.", primary, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
        $ast = MKAbsyn__ARRAY(for_or_el.ast);
      } else {
        $ast = MKAbsyn__CALL(MKAbsyn__CREF_5fIDENT(mmc_mk_scon(ARRAY_REDUCTION_NAME), mmc_mk_nil()),for_or_el.ast,mmc_mk_nil());
      }
    }
  | T_END { $ast = MKAbsyn__END; }
  )
  ;
  finally{ OM_POP(3); }

matrix_expression_list returns [void* ast]
@init{ OM_PUSHZ2(e1, e2); } :
  e1=expression_list (SEMICOLON e2=matrix_expression_list)? { ast = mmc_mk_cons(e1, or_nil(e2)); }
  ;
  finally{ OM_POP(2); }

component_reference__function_call returns [void* ast]
@init{ OM_PUSHZ4(cr.ast, /*ids,*/ fc, e.ast, $ast); i = 0; } :
  /* julia gc barfs on this one
  (cr=component_reference LESS ids=name_list GREATER fc=function_call) =>
  cr=component_reference LESS ids=name_list GREATER fc=function_call {
    modelicaParserAssert(metamodelica_enabled(), "Polymorphic type specifiers are only available in MetaModelica",
      component_reference__function_call, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
    $ast = MKAbsyn__CALL(cr.ast, fc, ids);
  }
  | */
  cr=component_reference ( fc=function_call (DOT e=expression[metamodelica_enabled()])? )? {
      if (fc != NULL) {
        $ast = MKAbsyn__CALL(cr.ast, fc, mmc_mk_nil());
        if (e.ast != 0) {
          modelicaParserAssert(ModelicaParser_langStd >= 1000, "Dot operator is not allowed in function calls in current Modelica standards.", component_reference__function_call, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition);
          $ast = MKAbsyn__DOT($ast, e.ast);
        }
      } else {
        $ast = MKAbsyn__CREF(cr.ast);
      }
    }
  | i=INITIAL LPAR RPAR {
      $ast = MKAbsyn__CREF_5fIDENT(mmc_mk_scon("initial"), mmc_mk_nil());
      $ast = MKAbsyn__CALL($ast,MKAbsyn__FUNCTIONARGS(mmc_mk_nil(),mmc_mk_nil()),mmc_mk_nil());
    }
  ;
  finally{ OM_POP(4); }

name_path_end returns [void* ast]
@init{ OM_PUSHZ1(np); } :
  np=name_path EOF
  {
    $ast = np;
  }
  ;
  finally{ OM_POP(1); }

name_path returns [void* ast]
@init{ dot = 0; OM_PUSHZ1(np); } :
  (dot=DOT)? np=name_path2
  {
    ast = dot ? MKAbsyn__FULLYQUALIFIED(np) : np;
  }
  ;
  finally{ OM_POP(1); }

name_path2 returns [void* ast]
@init{ id = 0; OM_PUSHZ1(p); } :
    { LA(2) != DOT }? (id=IDENT|id=CODE) { ast = MKAbsyn__IDENT(token_to_scon(id)); }
  | (id=IDENT | id=CODE) DOT p=name_path2 { ast = MKAbsyn__QUALIFIED(token_to_scon(id),p); }
  ;
  finally{ OM_POP(1); }

name_path_star returns [void* ast, int unqual, void* lst]
@init{ id = 0; uq = 0; OM_PUSHZ5(mlst, p.ast, p.lst, $lst, $ast); } :
    { LA(2) != DOT || LA(3) == LBRACE }? (id=IDENT|id=CODE) ( uq=STAR_EW | DOT LBRACE mlst=name_path_group RBRACE )?
    {
      $ast = MKAbsyn__IDENT(token_to_scon(id));
      $unqual = uq != 0;
      $lst = mlst;
    }
  | (id=IDENT|id=CODE) DOT p=name_path_star
    {
      $ast = MKAbsyn__QUALIFIED(token_to_scon(id),p.ast);
      $unqual = p.unqual;
      $lst = p.lst;
    }
  ;
  finally{ OM_POP(5); }

name_path_group returns [void* ast]
@init{ id1 = 0; id2 = 0; void *tmp = NULL; OM_PUSHZ2(rest, tmp); } :
  (id1=IDENT|id1=CODE) (EQUALS (id2=IDENT|id2=CODE))? (COMMA rest=name_path_group)?
    {
      tmp = token_to_scon(id1);
      $ast = mmc_mk_cons_typed(MKAbsyn_Import, id2 ? MKAbsyn__GROUP_5fIMPORT_5fRENAME(tmp,token_to_scon(id2)) :
                           MKAbsyn__GROUP_5fIMPORT_5fNAME(tmp),
                     or_nil(rest));
    }
  ;
  finally{ OM_POP(2); }

component_reference_end returns [void* ast]
@init{ OM_PUSHZ1(cr.ast); } :
  cr=component_reference EOF
  {
    $ast = cr.ast;
  }
  ;
  finally{ OM_POP(1); }

component_reference returns [void* ast, int isNone]
@init{ OM_PUSHZ2(cr.ast, $ast); dot = 0; cr.isNone = 0; } :
  (dot=DOT)? cr=component_reference2
    {
      $ast = dot ? MKAbsyn__CREF_5fFULLYQUALIFIED(cr.ast) : cr.ast;
      $isNone = cr.isNone;
    }
  | ALLWILD { $ast = MKAbsyn__ALLWILD; $isNone = false; }
  | WILD { $ast = MKAbsyn__WILD; $isNone = false; }
  ;
  finally{ OM_POP(2); }

component_reference2 returns [void* ast, int isNone]
@init { id = 0; OM_PUSHZ2(cr.ast, arr); } :
    (id=IDENT | id=OPERATOR) ( arr=array_subscripts )? ( DOT cr=component_reference2 )?
    {
      if (cr.ast) {
        $ast = MKAbsyn__CREF_5fQUAL(token_to_scon(id), or_nil(arr), cr.ast);
        $isNone = false;
      }
      else {
        $isNone = metamodelica_enabled() && strcmp("NONE",(char*)$id.text->chars) == 0;
        $ast = MKAbsyn__CREF_5fIDENT(token_to_scon(id), or_nil(arr));
      }
    }
  ;
  finally{ OM_POP(2); }

function_call returns [void* ast]
@init { OM_PUSHZ1(fa); } :
  LPAR fa=function_arguments RPAR { ast = fa; }
  ;
  finally{ OM_POP(1); }

function_arguments returns [void* ast]
@init{ OM_PUSHZ2(for_or_el.ast, namel); for_or_el.isFor = 0; } :
  for_or_el=for_or_expression_list (namel=named_arguments)?
    {
      if (for_or_el.isFor)
        ast = for_or_el.ast;
      else
        ast = MKAbsyn__FUNCTIONARGS(for_or_el.ast, or_nil(namel));
    }
  ;
  finally{ OM_POP(2); }

for_or_expression_list returns [void* ast, int isFor]
@init{ OM_PUSHZ3(e.ast, el, forind); } :
  ( {LA(1)==IDENT || (LA(1)==OPERATOR && LA(2) == EQUALS) || LA(1) == RPAR || LA(1) == RBRACE}? { $ast = mmc_mk_nil(); $isFor = 0; }
  | ( e=expression[1]
      ( ({LA(1)==COMMA}? el=for_or_expression_list2)
      | (threaded=THREADED? FOR forind=for_indices)
      )?
    )
    {
      if (el != NULL) {
        $ast = mmc_mk_cons_typed(MKAbsyn_Exp, e.ast, el);
      } else if (forind != NULL) {
        $ast = MKAbsyn__FOR_5fITER_5fFARG(e.ast, threaded ? MKAbsyn__THREAD : MKAbsyn__COMBINE, forind);
      } else {
        $ast = mmc_mk_cons_typed(MKAbsyn_Exp, e.ast, mmc_mk_nil());
      }
      $isFor = forind != 0;
    }
  )
  ;
  finally{ OM_POP(3); }

for_or_expression_list2 returns [void* ast]
@init{
  OM_PUSHZ2(e.ast, ast);
  ast = mmc_mk_nil();
} :
  (COMMA (e=expression[1] { ast = mmc_mk_cons_typed(MKAbsyn_Exp, e.ast, or_nil(ast)); } | {LA(1) != COMMA && LA(2) == EQUALS}? ))* {ast = listReverseInPlace(ast);}
  ;
  finally{ OM_POP(2); }

named_arguments returns [void* ast]
@init{ OM_PUSHZ2(a, as); } :
  a=named_argument (COMMA as=named_arguments)? { ast = mmc_mk_cons_typed(MKAbsyn_NamedArg, a, or_nil(as)); }
  ;
  finally{ OM_POP(2); }

named_argument returns [void* ast]
@init{ id = 0; OM_PUSHZ1(e.ast); } :
  ( id=IDENT | id=OPERATOR) EQUALS e=expression[1] { ast = MKAbsyn__NAMEDARG(token_to_scon(id),e.ast); }
  ;
  finally{ OM_POP(1); }

output_expression_list [int* isTuple] returns [void* ast]
@init{ OM_PUSHZ2(el, e1.ast); } :
  ( RPAR
    {
      ast = mmc_mk_nil();
      *isTuple = true;
    }
  | COMMA {*isTuple = true;} el=output_expression_list[isTuple]
      {
        $ast = mmc_mk_cons_typed(MKAbsyn_Exp, MKAbsyn__CREF(MKAbsyn__WILD), el);
      }
  | e1=expression[metamodelica_enabled()]
    ( COMMA {*isTuple = true;} el=output_expression_list[isTuple]
      {
        if (isNotNil(el))
        {
          ast = mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, el);
        }
        else
        {
          ast = mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, mmc_mk_cons_typed(MKAbsyn_Exp, MKAbsyn__CREF(MKAbsyn__WILD), el));
        }
      }
    | RPAR
      {
        ast = *isTuple ? mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, mmc_mk_nil()) : e1.ast;
      }
    )
  )
  ;
  finally{ OM_POP(2); }

expression_list returns [void* ast]
@init { OM_PUSHZ2(e1.ast, el); } :
  e1=expression[metamodelica_enabled()] (COMMA el=expression_list)? { ast = (el == NULL ? mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, mmc_mk_nil()) : mmc_mk_cons_typed(MKAbsyn_Exp, e1.ast, el)); }
  ;
  finally{ OM_POP(2); }

array_subscripts returns [void* ast]
@init{ OM_PUSHZ1(sl); } :
  LBRACK sl=subscript_list RBRACK { ast = sl; }
  ;
  finally{ OM_POP(1); }

subscript_list returns [void* ast]
@init{ OM_PUSHZ2(s1, s2); } :
  s1=subscript ( COMMA s2=subscript_list )? { ast = mmc_mk_cons_typed(MKAbsyn_Subscript, s1, or_nil(s2)); }
  ;
  finally{ OM_POP(2); }

subscript returns [void* ast]
@init{ OM_PUSHZ1(e.ast); } :
    e=expression[metamodelica_enabled()] { ast = MKAbsyn__SUBSCRIPT(e.ast); }
  | COLON { ast = MKAbsyn__NOSUB; }
  ;
  finally{ OM_POP(1); }

comment returns [void* ast]
@init{ OM_PUSHZ3(cmt, ann, ast); } :
  (cmt=string_comment (ann=annotation)?)
    {
       if (cmt || ann) {
         ann = mmc_mk_some_or_none(ann);
         cmt = mmc_mk_some_or_none(cmt);
         ast = MKAbsyn__COMMENT(ann, cmt);
       }
    }
  ;
  finally{ OM_POP(3); }

string_comment returns [void* ast]
@declarations { pANTLR3_STRING t1; }
@init { s1 = 0; s2 = 0; ast = 0; } :
  ( s1=STRING { t1 = s1->getText(s1); } (PLUS s2=STRING {t1->appendS(t1,s2->getText(s2));})*
    { ast = mmc_mk_scon((char*)t1->chars); }
  )?
  ;

annotation returns [void* ast]
@init{ OM_PUSHZ1(cmod); } :
  T_ANNOTATION cmod=class_modification { ast = MKAbsyn__ANNOTATION(cmod); }
  ;
  finally{ OM_POP(1); }


/* Code quotation mechanism */

code_expression returns [void* ast]
@init{ initial = 0; eq = 0; constr = 0; alg = 0; e.ast = 0; m.ast = 0; el.ast = 0; name = 0; cr.ast = 0; } :
  ( CODE LPAR
    ( (initial=INITIAL)?
      ( (EQUATION eq=code_equation_clause)
       |(CONSTRAINT constr=code_constraint_clause)
       |(T_ALGORITHM alg=code_algorithm_clause))
    | (LPAR expression[metamodelica_enabled()] RPAR) => e=expression[metamodelica_enabled()]   /* Allow Code((<expr>)) */
    | m=modification
    | (expression[metamodelica_enabled()] RPAR) => e=expression[metamodelica_enabled()]
    | el=element (SEMICOLON)?
    )  RPAR
      {
        if (e.ast) {
          ast = MKAbsyn__CODE(MKAbsyn__C_5fEXPRESSION(e.ast));
        } else if ($m.ast) {
          ast = MKAbsyn__CODE(MKAbsyn__C_5fMODIFICATION($m.ast));
        } else if (eq) {
          ast = MKAbsyn__CODE(MKAbsyn__C_5fEQUATIONSECTION(mmc_mk_bcon(initial), eq));
        } else if (constr) {
          ast = MKAbsyn__CODE(MKAbsyn__C_5fCONSTRAINTSECTION(mmc_mk_bcon(initial), constr));
        } else if (alg) {
          ast = MKAbsyn__CODE(MKAbsyn__C_5fALGORITHMSECTION(mmc_mk_bcon(initial), alg));
        } else {
          ast = MKAbsyn__CODE(MKAbsyn__C_5fELEMENT($el.ast));
        }
      }
  | CODE_NAME LPAR name=name_path RPAR {ast = MKAbsyn__CODE(MKAbsyn__C_5fTYPENAME(name));}
  | CODE_ANNOTATION cmod=class_modification { ast = MKAbsyn__CODE(MKAbsyn__C_5fMODIFICATION(MKAbsyn__CLASSMOD(cmod, MKAbsyn__NOMOD))); }
  | CODE_VAR LPAR cr=component_reference RPAR {ast = MKAbsyn__CODE(MKAbsyn__C_5fVARIABLENAME(cr.ast));}
  )
  ;

code_equation_clause returns [void* ast]
@init{ e.ast = 0; as = 0; } :
  ( e=equation SEMICOLON as=code_equation_clause?
    {
      ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, e.ast, or_nil(as));
    }
  )
  ;

code_constraint_clause returns [void* ast]
@init{ e.ast = 0; as = 0; } :
  e=equation SEMICOLON as=code_constraint_clause?
    {
      ast = mmc_mk_cons_typed(MKAbsyn_EquationItem, e.ast,or_nil(as));
    }
  ;

code_algorithm_clause returns [void* ast]
@init{ al.ast = 0; as = 0; } :
  al=algorithm SEMICOLON as=code_algorithm_clause?
    {
      ast = mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, al.ast, or_nil(as));
    }
  ;

/* End Code quotation mechanism */


top_algorithm returns [void* ast]
@init{ e.ast = 0; a = 0; cmt = 0; } :
  ( (expression[metamodelica_enabled()] (SEMICOLON|EOF))=> e=expression[metamodelica_enabled()]
  | ( a=top_assign_clause_a
    | a=conditional_equation_a
    | a=for_clause_a
    | a=parfor_clause_a
    | a=while_clause
    | a=try_clause
    )
    cmt=comment
  )
    {
      if (!e.ast) {
        cmt = mmc_mk_some_or_none(cmt);
        $ast = GlobalScript__IALG(MKAbsyn__ALGORITHMITEM(a, cmt, PARSER_INFO($start)));
      } else {
        $ast = GlobalScript__IEXP(e.ast, PARSER_INFO($start));
      }
    }
  ;

top_assign_clause_a returns [void* ast]
@init{ e1 = 0; e2.ast = 0; } :
  e1=simple_expression ASSIGN e2=expression[metamodelica_enabled()]
    {
      ast = MKAbsyn__ALG_5fASSIGN(e1,e2.ast);
    }
  ;

interactive_stmt returns [void* ast]
@declarations { int last_sc = 0; }
@init{ ss = 0; } :
  // A list of expressions or algorithms separated by semicolons and optionally ending with a semicolon
  BOM? ss=interactive_stmt_list (SEMICOLON {last_sc=1;})? EOF
    {
      ast = GlobalScript__ISTMTS(or_nil(ss), mmc_mk_bcon(last_sc));
    }
  ;

interactive_stmt_list returns [void* ast]
@init { a.ast = 0; $ast = mmc_mk_nil(); void *val; } :
  a=top_algorithm {$ast = mmc_mk_cons_typed(MKAbsyn_Algorithm, a.ast, $ast);} (SEMICOLON a=top_algorithm {$ast = mmc_mk_cons_typed(MKAbsyn_AlgorithmItem, a.ast, $ast);})*
  {
    /* We build the list using iteration instead of recursion to save
     * stack space, so we need to reverse the result. */
    $ast = listReverseInPlace($ast);
  }
  ;



/* MetaModelica */
match_expression returns [void* ast]
@init{ ty = 0; exp.ast = 0; cmt = 0; es = 0; cs = 0; } :
  ( (ty=MATCHCONTINUE exp=expression[metamodelica_enabled()] cmt=string_comment
     es=local_clause
     cs=cases
     END_MATCHCONTINUE)
  | (ty=MATCH exp=expression[metamodelica_enabled()] cmt=string_comment
     es=local_clause
     cs=cases
     END_MATCH)
  )
     {
       ast = MKAbsyn__MATCHEXP(ty->type==MATCHCONTINUE ? MKAbsyn__MATCHCONTINUE : MKAbsyn__MATCH, exp.ast, or_nil(es), cs, mmc_mk_some_or_none(cmt));
     }
  ;

local_clause returns [void* ast]
@init{ el = 0; } :
  (LOCAL el=element_list[0])?
    {
      ast = el;
    }
  ;

cases returns [void* ast]
@init{ c.ast = 0; cs.ast = 0; } :
  c=onecase cs=cases2
    {
      $ast = mmc_mk_cons_typed(MKAbsyn_Case, c.ast, cs.ast);
    }
  ;

cases2 returns [void* ast]
@init{ el = 0; cmt = 0; es = 0; eqs = 0; th = 0; exp.ast = 0; c.ast = 0; cs.ast = 0; } :
  ( (el=ELSE (cmt=string_comment es=local_clause ((EQUATION eqs=equation_list_then)|(al=T_ALGORITHM algs=algorithm_annotation_list[NULL,1]))? th=THEN)? exp=expression[metamodelica_enabled()] SEMICOLON)?
    {
      if (es != NULL)
        c_add_source_message(NULL,2, ErrorType_syntax, ErrorLevel_warning, "case local declarations are deprecated. Move all case- and else-declarations to the match local declarations.",
                             NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition+1,
                             ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
      if ($th) $el = $th;
      if (exp.ast) {
       $ast = mmc_mk_cons_typed(MKAbsyn_Case, MKAbsyn__ELSE(or_nil(es),eqs ? MKAbsyn__EQUATIONS(eqs) : (al ? MKAbsyn__ALGORITHMS(algs.ast) : MKAbsyn__EQUATIONS(mmc_mk_nil())),exp.ast,PARSER_INFO($el),mmc_mk_some_or_none(cmt),PARSER_INFO($start)),mmc_mk_nil());
      } else {
       $ast = mmc_mk_nil();
      }
    }
  | c=onecase cs=cases2
    {
      $ast = mmc_mk_cons_typed(MKAbsyn_Case, c.ast, cs.ast);
    }
  )
  ;

onecase returns [void* ast]
@init{ pat.ast = 0; guard.ast = 0; cmt = 0; es = 0; eqs = 0; th = 0; exp.ast = 0; } :
  (CASE pat=pattern ((IF|GUARD) guard=expression[metamodelica_enabled()])? cmt=string_comment es=local_clause ((EQUATION eqs=equation_list_then)|(al=T_ALGORITHM algs=algorithm_annotation_list[NULL,1]))? th=THEN exp=expression[metamodelica_enabled()] SEMICOLON)
    {
        if (es != NULL) {
          c_add_source_message(NULL,2, ErrorType_syntax, ErrorLevel_warning, "case local declarations are deprecated. Move all case- and else-declarations to the match local declarations.",
                               NULL, 0, $start->line, $start->charPosition+1, LT(1)->line, LT(1)->charPosition+1,
                               ModelicaParser_readonly, ModelicaParser_filename_C_testsuiteFriendly);
        }
        $ast = MKAbsyn__CASE(pat.ast,mmc_mk_some_or_none(guard.ast),pat.info,or_nil(es),eqs ? MKAbsyn__EQUATIONS(eqs) : (al ? MKAbsyn__ALGORITHMS(algs.ast) : MKAbsyn__EQUATIONS(mmc_mk_nil())),exp.ast,PARSER_INFO($th),mmc_mk_some_or_none(cmt),PARSER_INFO($start));
    }
  ;

pattern returns [void* ast, void* info] :
  e=expression[0] {$ast = e.ast; $info = PARSER_INFO($start);}
  ;
