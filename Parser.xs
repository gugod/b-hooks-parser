#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_parser.h"

#ifdef PL_parser
#define PL_linestr (PL_parser->linestr)
#define PL_bufptr  (PL_parser->bufptr)
#define PL_bufend  (PL_parser->bufend)
#endif

const char *
hook_parser_get_linestr (pTHX) {
	return SvPVX (PL_linestr);
}

UV
hook_parser_get_linestr_offset (pTHX) {
	char *linestr = SvPVX (PL_linestr);
	return PL_bufptr - linestr;
}

void
hook_parser_set_linestr (pTHX_ const char *new_value) {
	int new_len = strlen (new_value);
	char *old_linestr = SvPVX (PL_linestr);

	SvGROW (PL_linestr, new_len);

	if (SvPVX (PL_linestr) != old_linestr) {
		croak ("forced to realloc PL_linestr for line %s,"
		       " bailing out before we crash harder", SvPVX (PL_linestr));
	}

	Copy (new_value, SvPVX (PL_linestr), new_len + 1, char);

	SvCUR_set (PL_linestr, new_len);
	PL_bufend = SvPVX(PL_linestr) + new_len;
}

MODULE = B::Hooks::Parser  PACKAGE = B::Hooks::Parser  PREFIX = hook_parser_

const char *
hook_parser_get_linestr ()
	C_ARGS:
		aTHX

UV
hook_parser_get_linestr_offset ()
	C_ARGS:
		aTHX

void
hook_parser_set_linestr (new_value)
		const char *new_value
	C_ARGS:
		aTHX_ new_value
