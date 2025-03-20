%%% ====================================================================
%%%  @BibTeX-style-file{
%%%     author          = "David Lamkin",
%%%     version         = "B.04",
%%%     date            = "2025",
%%%     filename        = "csecn.bst",
%%%     address         = "",
%%%     checksum        = "",
%%%     email           = "formatwithstyle@outlook.com",
%%%     supported       = "yes",
%%%     abstract        = "The file produces bibliographies more or
%%%                        less in the Council of Science Editors (CSE)
%%%                        citation-name (ninth edition) format. It 
%%%                        was adapted from Patrick W. Daly's plainnat.bst,
%%%                        incorporating features of Alan Rogers' cbe.bst
%%%                        and Patrick W. Daly and Arthur Ogawa's 
%%%                        merlin.mbs".
%%%
%%%     Usage: The preamble of the .tex document has to contain at least:
%%% 
%%%     \usepackage[numbers,sort&compress]{natbib} % and EITHER
%%%     \bibpunct[, ]{[}{]}{,}{n}{}{,} % for numbers in square brackets OR
%%%     \bibpunct[, ]{}{}{,}{s}{}{,} % for superscript numbers
%%%
%%%     The inclusion of
%%%
%%%     \usepackage{doi} 
%%%     \renewcommand{\doitext}{https://doi.org/} 
%%%
%%%     (or equivalent) is also required in order to hyperlink DOI 
%%%     numbers to doi.org and output the appropriate text prefix. 
%%%
%%%     To get something other than square brackets in the list, say:
%%%
%%%     \makeatletter % @ is now a letter
%%%     \def\bibleftdelim{}
%%%     \def\bibrightdelim{.}
%%%     \def\@biblabel#1{\bibleftdelim #1\bibrightdelim}
%%%     \makeatother % @ is a symbol again
%%%
%%%     These labels will have no brackets and be followed by a full point.
%%%  }
%%% ====================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BibTeX `csecn' bibliography style (20-Mar-25 version)
% An adaptation of the `plainnat' style, for use with the natbib package.
% Copyright (C) 2025, All rights reserved.
% Copying of this file is allowed, provided that if you make any changes at all
% you name it something other than `csecn.bst', `csecs.bst' or `cseny.bst'.
% This restriction helps ensure that all copies are identical.
%
% This style should be used with the `natbib' LaTeX style (natbib.sty).
% The form of the \bibitem entries is
%   \bibitem[Jones et al(1990)]{key}...
% The essential feature is that the label (the part in brackets) consists
% of the author names, as they should appear in the citation, with the year
% in parentheses following. There must be no space before the opening
% parenthesis!
% \cite's or \citet's come out like "[1]" or "Jones [1]" in the text, and
% "[1] Jones A." in the bibliography. Author (and editor) names appear as 
% last name, initials. A `year' field is required for every entry, and so
% is either an author (or in some cases, an editor) field or a key field.
%
% History:
%   15-sep-86   (SK,OP) Original version, by Susan King and Oren Patashnik.
%   10-nov-86   (OP) Truncated the sort.key$ string to the correct length
%               in bib.sort.order to eliminate error message.
%   24-jan-88   (OP) Updated for BibTeX version 0.99a, from alpha.bst 0.99a;
%               apalike now sorts by author, then year, then title;
%               THIS `apalike' VERSION DOES NOT WORK WITH BIBTEX 0.98i.
%   20-mar-25   Updated for CSE citation-name (9th edition), for BibTeX 0.99d;
%               csecn sorts by author, then title.

ENTRY
  { address
    archive
    assignee
    author
    booktitle
    chapter
    collaboration
    doi
    edition
    editor
    eid
    howpublished
    institution
    inventor
    journal
    key
    lastchecked
    month
    note
    number
    numpages
    organization
    pages
    publisher
    school
    series
    title
    type
    url
    urldate
    volume
    year
  }
  {}
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { "; " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {fin.entry}
{ add.period$	
  write$ 
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {add.blank}
{  
  " " * before.all 'output.state :=
}

FUNCTION {no.blank.or.punct}
{  
  "" * before.all 'output.state :=
}

FUNCTION {date.block}
{
  ";" * no.blank.or.punct
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

STRINGS {z}

FUNCTION {remove.dots}
{ 'z :=
   ""
   { z empty$ not }
   { z #1 #2 substring$
     duplicate$ "\." =
       { z #3 global.max$ substring$ 'z :=  * }
       { pop$
         z #1 #1 substring$
         z #2 global.max$ substring$ 'z :=
         duplicate$ "." = 'pop$
           { * }
         if$
       }
     if$
   }
   while$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {capitalize}
{ "u" change.case$ "t" change.case$ }

FUNCTION {space.word}
{ " " swap$ * " " * }

% Here are the language-specific definitions for explicit words.
% Each function has a name bbl.xxx where xxx is the English word.
% The language selected here is ENGLISH

FUNCTION {bbl.and}
{ "and" }

FUNCTION {bbl.etal}
{ "et~al" }

FUNCTION {bbl.editors}
{ "editors" }

FUNCTION {bbl.editor}
{ "editor" }

FUNCTION {bbl.inventors} % special for @patent
{ "inventors" }

FUNCTION {bbl.inventor} % special for @patent
{ "inventor" }

FUNCTION {bbl.assignee} % special for @patent
{ "assignee" }

FUNCTION {bbl.edby}
{ "edited by" }

FUNCTION {bbl.edition}
{ "ed" }	

FUNCTION {bbl.volume}
{ "vol." }

FUNCTION {bbl.of}
{ "of" }

FUNCTION {bbl.number}
{ "no." }

FUNCTION {bbl.nr}
{ "no." }

FUNCTION {bbl.in}
{ "in" }

FUNCTION {bbl.pages}
{ "p" }

FUNCTION {bbl.page}
{ "p" }

FUNCTION {bbl.eidpp}
{ "pages" }

FUNCTION {bbl.chapter}
{ "chapter" }

FUNCTION {bbl.techrep}
{ "Technical {R}eport" }

FUNCTION {bbl.mthesis}
{ "[master's thesis]" }

FUNCTION {bbl.phdthesis}
{ "[dissertation]" }

FUNCTION {bbl.first}
{ "1st" }

FUNCTION {bbl.second}
{ "2nd" }

FUNCTION {bbl.third}
{ "3rd" }

FUNCTION {bbl.fourth}
{ "4th" }

FUNCTION {bbl.fifth}
{ "5th" }

FUNCTION {bbl.st}
{ "st" }

FUNCTION {bbl.nd}
{ "nd" }

FUNCTION {bbl.rd}
{ "rd" }

FUNCTION {bbl.th}
{ "th" }

FUNCTION {eng.ord}
{ duplicate$ "1" swap$ *
  #-2 #1 substring$ "1" =
     { bbl.th * }
     { duplicate$ #-1 #1 substring$
       duplicate$ "1" =
         { pop$ bbl.st * }
         { duplicate$ "2" =
             { pop$ bbl.nd * }
             { "3" =
                 { bbl.rd * }
                 { bbl.th * }
               if$
             }
           if$
          }
       if$
     }
   if$
}

FUNCTION {bibinfo.check}
{ swap$
  duplicate$ missing$
    {
      pop$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ pop$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}

FUNCTION {bibinfo.warn}
{ swap$
  duplicate$ missing$
    {
      swap$ "missing " swap$ * " in " * cite$ * warning$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ "empty " swap$ * " in " * cite$ * warning$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }

STRINGS  { bibinfo }

FUNCTION {format.names}
%
% Include the names of up to five authors in the list.
% If there are more than five, list only "Author A et al".
%
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{ f{}}{ jj}" format.name$
      remove.dots
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        { nameptr #1
          #1 + =
          numnames #5
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            { s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                { " " * bbl.etal * }
                { ", " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}

FUNCTION {format.editor.names}
%
% Follow the same rule as for a list of authors. 
%
{
  format.names
}

FUNCTION {format.authors}
{ author "author" format.names
    duplicate$ empty$ 'skip$
    { collaboration "collaboration" bibinfo.check
      duplicate$ empty$ 'skip$
        { " (" swap$ * ")" * }
      if$
      *
    }
  if$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {get.bbl.editor}
{ editor num.names$ #1 > 'bbl.editors 'bbl.editor if$ }

FUNCTION {get.bbl.inventor} % special for @patent
{ inventor num.names$ #1 > 'bbl.inventors 'bbl.inventor if$ }

FUNCTION {format.editors}
{ editor "editor" format.names duplicate$ empty$ 'skip$
    {
      ", " *
      get.bbl.editor *
    }
  if$
}

FUNCTION {format.inventors} % special for @patent
{ inventor "inventor" format.names duplicate$ empty$ 'skip$
    {
      ", " *
      get.bbl.inventor *
    }
  if$
}

FUNCTION {format.assignee} % special for @patent
{ assignee "assignee" bibinfo.check duplicate$ empty$ 'skip$
    {
      ", " *
      bbl.assignee *
    }
  if$
}

FUNCTION {urldate.check}
{ lastchecked empty$
    { urldate empty$
        { "" }
    { " [accessed " urldate * "]" * add.period$ }
      if$
    }
    { " [accessed " lastchecked * "]" * add.period$ }
  if$
}

FUNCTION {format.doi.or.url}
%
% Includes the DOI if available, or else the URL
%
{ doi empty$
    { url empty$
        { "" }
    { urldate.check * "\url{" url * "}" * }
      if$
    }
    { "\doi{" doi * "}" * }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {word.in}
{ bbl.in capitalize ": " * }

FUNCTION {output.year.month.check}
%
% For functions where a month might need to appear with the date:
% misc, newspaper, patent, techreport, unpublished
%
{ year empty$
    { "empty year in " cite$ * "; no date information output" * warning$ }
    { write$
      ". " year *  %  no extra.label here
      month empty$
      { "" * }
      { " " * month * }
      if$
      mid.sentence 'output.state :=
    }
  if$
}

FUNCTION {format.date}
{ year "year" bibinfo.check duplicate$ empty$
    {
      "empty year in " cite$ * "; set to [date unknown]" * warning$
       pop$ "{[date unknown]}"
    }
    'skip$
  if$
  before.all 'output.state :=
  mid.sentence 'output.state :=
}

FUNCTION {format.journal.date} 
{ year "year" bibinfo.check duplicate$ empty$
    {
      "empty year in " cite$ * "; set to ????" * warning$
       pop$ "????"
    }
    'skip$
  if$
  before.all 'output.state :=
  after.sentence 'output.state :=
}

FUNCTION {format.btitle}
%
% Book titles are converted to "Sentence case"
%
{ title "title" bibinfo.check
  duplicate$ empty$ 'skip$
    { "t" change.case$ }
  if$
}

FUNCTION {format.ptitle}
%
% Conference proceedings titles retain "Title Case"
%
{ title "title" bibinfo.check
  duplicate$ empty$ 'skip$
    {
    }
  if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {tie.or.space.prefix} % (from merlin)
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { bbl.volume capitalize volume tie.or.space.prefix
      "volume" bibinfo.check * *
      series "series" bibinfo.check
      duplicate$ empty$ 'pop$
        { "(" swap$ * "; " * swap$ * ")" * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { number "number" bibinfo.check }
            { output.state mid.sentence =	
                { "" }
                { "" }
              if$
              number "number" bibinfo.check *
              series "series" bibinfo.check
              duplicate$ empty$ 'pop$
                { "(" swap$ * "; " * swap$ * ")" * }
              if$
            }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {is.num}
{ chr.to.int$
  duplicate$ "0" chr.to.int$ < not
  swap$ "9" chr.to.int$ > not and
}

FUNCTION {extract.num}
{ duplicate$ 't :=
  "" 's :=
  { t empty$ not }
  { t #1 #1 substring$
    t #2 global.max$ substring$ 't :=
    duplicate$ is.num
      { s swap$ * 's := }
      { pop$ "" 't := }
    if$
  }
  while$
  s empty$
    'skip$
    { pop$ s }
  if$
}

FUNCTION {convert.edition}
{ extract.num "l" change.case$ 's :=
  s "first" = s "1" = or
    { bbl.first 't := }
    { s "second" = s "2" = or
        { bbl.second 't := }
        { s "third" = s "3" = or
            { bbl.third 't := }
            { s "fourth" = s "4" = or
                { bbl.fourth 't := }
                { s "fifth" = s "5" = or
                    { bbl.fifth 't := }
                    { s #1 #1 substring$ is.num
                        { s eng.ord 't := }
                        { edition 't := }
                      if$
                    }
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
  t
}

FUNCTION {format.edition}
{ edition duplicate$ empty$ 'skip$
    {
      convert.edition
      output.state mid.sentence =
        { "l" }
        { "t" }
      if$ change.case$
      "edition" bibinfo.check
      " " * bbl.edition *
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
		{ #1 'multiresult := }
		{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
		{ bbl.pages pages n.dashify tie.or.space.connect }
		{ bbl.page pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.journal.pages}
{ pages duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          ":" *
          swap$
          n.dashify
          "pages" bibinfo.check
          *
        }
      if$
    }
  if$
}

FUNCTION {format.newspaper.pages} % special for @newspaper
%
% Copy of {format.journal.pages} with added space for newspaper pages
%
{ pages duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          ": " *  %  ":" *
          swap$
          n.dashify
          "pages" bibinfo.check
          *
        }
      if$
    }
  if$
}

FUNCTION {format.journal.eid}
{ eid "eid" bibinfo.check
  duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$ 'skip$
      {
        ":" *  	
      }
      if$
      swap$ * ". " *
      numpages empty$ 'skip$
        { bbl.eidpp numpages tie.or.space.prefix
          "numpages" bibinfo.check * *
          " (" swap$ * ")" * *
        }
      if$
    }
  if$
}

FUNCTION {format.vol.num} % replaces {format.vol.num.pages}
%
% Renamed as {format.vol.num} since it doesn't include pages
% We can still have a newspaper.pages equivalent...
%
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      "(" swap$ * ")" *
    }
  if$ *
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    { "" }
    { type empty$
		{ bbl.chapter capitalize }
		{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
    }
  if$
}

FUNCTION {format.booktitle}
%
% Book titles are converted to "Sentence case"
%
{ booktitle "booktitle" bibinfo.check
  duplicate$ empty$ 'skip$
    { "t" change.case$ }
  if$
}

FUNCTION {format.proctitle}
%
% Conference proceedings titles retain "Title Case"
%
{ booktitle "booktitle" bibinfo.check
  duplicate$ empty$ 'skip$
    {
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ format.booktitle duplicate$ empty$ 'skip$
    { editor "editor" format.editor.names duplicate$ empty$ 'pop$
        { ", " *
          get.bbl.editor
          ". " *
          * swap$
          * }
      if$
      word.in swap$ *
    }
  if$
}

FUNCTION {format.in.ed.proctitle}
{ format.proctitle duplicate$ empty$ 'skip$
    { editor "editor" format.editor.names duplicate$ empty$ 'pop$
        { ", " *
          get.bbl.editor
          ". " *
          * swap$
          * }
      if$
      word.in swap$ *
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$ 
      "[" * type "t" change.case$ "]" * 
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { bbl.techrep }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.patent.number} % special for @patent
{ 
  number "number" bibinfo.check
}

FUNCTION {format.article.crossref}
{ key duplicate$ empty$
    { pop$
      journal duplicate$ empty$
        { "need key or journal for " cite$ * " to crossref " * crossref * warning$ }
        { "journal" bibinfo.check word.in swap$ * }
      if$
    }
    { word.in swap$ * " " *}
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ volume duplicate$ empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      pop$ word.in
    }
    { bbl.volume capitalize
      swap$ tie.or.space.prefix "volume" bibinfo.check * * bbl.of space.word *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { series * }
          if$
        }
        { key * }
      if$
    }
    'skip$
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { format.booktitle duplicate$ empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
            }
            { word.in swap$ * }
          if$
        }
        { word.in key * " " *}
      if$
    }
    { word.in " " *}
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {format.conference.address} 
%
% For use in {inproceedings} and {proceedings}
%
{ address "address" bibinfo.check
}

FUNCTION {format.month}
%
% For use in {inproceedings} and {proceedings}
%
{ month empty$
    { "" }
    { month "month" bibinfo.check
    "" swap$ * "" *}
  if$
  remove.dots
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block	
  format.title "title" output.check
  new.block	
  crossref missing$
    { journal remove.dots
      "journal" bibinfo.check
      "journal" output.check
      format.journal.date "year" output.check
      date.block
      format.vol.num output
    }
    { format.article.crossref output.nonnull }
  if$
  eid empty$
    { format.journal.pages }
    { format.journal.eid }
  if$
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block	
  format.btitle "title" output.check
  new.sentence
  crossref missing$
    { format.edition output
      format.bvolume output
      new.sentence
      publisher "publisher" output.check
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check
  new.sentence
  format.number.series output
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  author format.key output
  new.block
  format.title "title" output.check
  new.block
  howpublished output
  address output	
  format.date "year" output.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  new.sentence
  crossref missing$
    { format.edition output
      format.bvolume output
      new.sentence
      publisher "publisher" output.check
      format.date "year" output.check
      new.sentence
      format.chapter.pages "chapter and pages" output.check
    }
    { format.chapter.pages "chapter and pages" output.check
      new.sentence
      format.book.crossref output.nonnull
    }
  if$
  format.pages "pages" output.check
  new.sentence
  format.number.series output
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      new.sentence
      format.edition output
      format.bvolume output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  format.date "year" output.check
  new.sentence
  format.pages "pages" output.check
  new.sentence
  format.number.series output
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.proctitle "booktitle" output.check
      format.bvolume output
      format.month output
      format.conference.address output
      new.sentence
      organization output
      publisher output
    }
    { format.incoll.inproc.crossref output.nonnull
    }
  if$
  format.date "year" output.check
  new.sentence
  format.pages "pages" output.check
  new.sentence
  format.number.series output
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.authors output
  author format.key output
  new.block
  format.btitle "title" output.check
  new.sentence
  format.edition output
  organization address new.block.checkb
  organization output
  format.date "year" output.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  add.blank
  bbl.mthesis format.thesis.type output.nonnull
  new.block
  school "school" output.check
  format.date "year" output.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  author format.key output
  new.block
  format.title output
  new.block
  howpublished output
  output.year.month.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {newspaper}
%
% This function is work in progress, to allow newspaper article 
% format to vary from that of a journal (date and pages at least).
% The journal fields should all perhaps be renamed to newspaper?
% The crossref might not be needed for a newspaper article.
%
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { journal remove.dots
      "journal" bibinfo.check
      "journal" output.check
      new.sentence
      output.year.month.check
      format.vol.num output
    }
    { format.article.crossref output.nonnull }
  if$
  eid empty$
    { format.newspaper.pages }  %  { format.journal.pages }
    { format.journal.eid }
  if$
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {patent}
%
% Requires inventor, assignee and number fields and a key in .bib
%
{ output.bibitem
  format.inventors "inventor" output.check
  format.assignee "assignee" output.check
  new.block
  format.title "title" output.check
  new.sentence
  format.patent.number output.nonnull
  output.year.month.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  add.blank
  bbl.phdthesis format.thesis.type output.nonnull
  new.block
  school "school" output.check
  format.date "year" output.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  format.editors output
  editor format.key output
  new.block
  format.ptitle "title" output.check
  format.bvolume output
  format.month output
  format.conference.address output
  new.sentence
  organization output
  publisher output
  new.sentence
  format.number.series output
  format.date "year" output.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  output.year.month.check
  new.sentence
  note output
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title "title" output.check
  output.year.month.check
  new.sentence
  note "note" output.check
  new.sentence
  format.doi.or.url output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"Jan"}
MACRO {feb} {"Feb"}
MACRO {mar} {"Mar"}
MACRO {apr} {"Apr"}
MACRO {may} {"May"}
MACRO {jun} {"Jun"}
MACRO {jul} {"Jul"}
MACRO {aug} {"Aug"}
MACRO {sep} {"Sep"}
MACRO {oct} {"Oct"}
MACRO {nov} {"Nov"}
MACRO {dec} {"Dec"}

MACRO {acmcs} {"ACM Comput. Surv."}
MACRO {acta} {"Acta Inf."}
MACRO {cacm} {"Commun. ACM"}
MACRO {ibmjrd} {"IBM J. Res. Dev."}
MACRO {ibmsj} {"IBM Syst.~J."}
MACRO {ieeese} {"IEEE Trans. Software Eng."}
MACRO {ieeetc} {"IEEE Trans. Comput."}
MACRO {ieeetcad} {"IEEE Trans. Comput. Aid. Des."}
MACRO {ipl} {"Inf. Process. Lett."}
MACRO {jacm} {"J.~ACM"}
MACRO {jcss} {"J.~Comput. Syst. Sci."}
MACRO {scp} {"Sci. Comput. Program."}
MACRO {sicomp} {"SIAM J. Comput."}
MACRO {tocs} {"ACM Trans. Comput. Syst."}
MACRO {tods} {"ACM Trans. Database Syst."}
MACRO {tog} {"ACM Trans. Graphic."}
MACRO {toms} {"ACM Trans. Math. Software"}
MACRO {toois} {"ACM Trans. Office Inf. Syst."}
MACRO {toplas} {"ACM Trans. Progr. Lang. Syst."}
MACRO {tcs} {"Theor. Comput. Sci."}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.lab.names}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " " * bbl.etal * }
    { #2 <
		'skip$
		{ s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
		    { " " * bbl.etal * }
			{ bbl.and space.word * s #2 "{vv~}{ll}" format.name$ * }
	  	if$
		}
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  "("
  *
  year duplicate$ empty$
     { pop$ "{????}" }
     'skip$
  if$
  *                   % the matching closing ")" comes in at reverse.pass
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$	
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't := 
      nameptr numnames = t "others" = and
	{ bbl.etal * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  #1 entry.max$ substring$
  'sort.label :=	
  sort.label	
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT	

STRINGS { longest.label last.label next.extra }

INTEGERS { longest.label.width last.extra.num number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
  label extra.label * ")" * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT		% by sort.label, title = final bibliography order

FUNCTION {begin.bib}
{   preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{" number.label int.to.str$ * "}" *
  write$ newline$
  "\providecommand{\natexlab}[1]{#1}"
  write$ newline$
  "\providecommand{\url}[1]{\normalfont{#1}}"
  write$ newline$
  "\providecommand{\doi}[1]{\normalfont{#1}}"
  write$ newline$	
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
