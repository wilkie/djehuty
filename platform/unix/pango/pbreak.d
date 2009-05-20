/*
 * pbreak.d
 *
 * This file holds bindings to pango's pango-pbreak.h.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.pango.pbreak;

import platform.unix.pango.types;
import platform.unix.pango.item;

extern(C):

struct _PangoLogAttr
{
  guint is_line_break;      /* Can break line in front of character */

  guint is_mandatory_break; /* Must break line in front of character */

  guint is_char_break;      /* Can break here when doing char wrap */

  guint is_white;           /* Whitespace character */

  /* cursor can appear in front of character (i.e. this is a grapheme
   * boundary, or the first character in the text)
   */
  guint is_cursor_position;

  /* Note that in degenerate cases, you could have both start/end set on
   * some text, most likely for sentences (e.g. no space after a period, so
   * the next sentence starts right away)
   */

  guint is_word_start;      /* first character in a word */
  guint is_word_end;      /* is first non-word char after a word */

  /* There are two ways to divide sentences. The first assigns all
   * intersentence whitespace/control/format chars to some sentence,
   * so all chars are in some sentence; is_sentence_boundary denotes
   * the boundaries there. The second way doesn't assign
   * between-sentence spaces, etc. to any sentence, so
   * is_sentence_start/is_sentence_end mark the boundaries of those
   * sentences.
   */
  guint is_sentence_boundary;
  guint is_sentence_start;  /* first character in a sentence */
  guint is_sentence_end;    /* first non-sentence char after a sentence */

  /* if set, backspace deletes one character rather than
   * the entire grapheme cluster
   */
  guint backspace_deletes_character;
};

/* Determine information about cluster/word/line breaks in a string
 * of Unicode text.
 */
void pango_break (gchar   *text,
		  int            length,
		  PangoAnalysis *analysis,
		  PangoLogAttr  *attrs,
		  int            attrs_len);

void pango_find_paragraph_boundary (gchar *text,
				    gint         length,
				    gint        *paragraph_delimiter_index,
				    gint        *next_paragraph_start);

void pango_get_log_attrs (char    *text,
			  int            length,
			  int            level,
			  PangoLanguage *language,
			  PangoLogAttr  *log_attrs,
			  int            attrs_len);

/* This is the default break algorithm, used if no language
 * engine overrides it. Normally you should use pango_break()
 * instead; this function is mostly useful for chaining up
 * from a language engine override.
 */
void pango_default_break (gchar   *text,
			  int            length,
			  PangoAnalysis *analysis,
			  PangoLogAttr  *attrs,
			  int            attrs_len);
