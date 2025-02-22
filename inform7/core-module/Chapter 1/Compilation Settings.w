[CompilationSettings::] Compilation Settings.

Settings affecting the compilation of the current project.

@ The Inform compiler has many settings coming from outside: for example, a
command-line switch allows indexing to be turned off. This is not something a
program's own source text should be able to control. But it also has settings
such as whether or not to use the serial comma, which should indeed be
controllable from source text.

Those are called "compilation settings", and are a ragbag accumulated through
two decades of historical accident. Most correspond to use options. Some are
meaningful only for works of IF and are inert for Basic Inform projects.

@e AUTHORIAL_MODESTY_UO from 0
@e DYNAMIC_MEMORY_ALLOCATION_UO
@e MEMORY_ECONOMY_UO
@e NO_DEPRECATED_FEATURES_UO
@e NUMBERED_RULES_UO
@e TELEMETRY_RECORDING_UO
@e SCORING_UO
@e NO_SCORING_UO
@e ENGINEERING_NOTATION_UO
@e UNABBREVIATED_OBJECT_NAMES_UO
@e INDEX_FIGURE_THUMBNAILS_UO
@e UNDO_PREVENTION_UO
@e SERIAL_COMMA_UO
@e PREDICTABLE_RANDOMISATION_UO
@e COMMAND_LINE_ECHOING_UO
@e AMERICAN_DIALECT_UO
@e FULL_LENGTH_ROOM_DESCRIPTIONS_UO
@e ABBREVIATED_ROOM_DESCRIPTIONS_UO
@e VERBOSE_ROOM_DESCRIPTIONS_UO
@e BRIEF_ROOM_DESCRIPTIONS_UO
@e SUPERBRIEF_ROOM_DESCRIPTIONS_UO

@ Note that Inform recognises these by their English names, so there would be no
need to translate this to other languages.

=
<notable-use-option-name> ::=
	authorial modesty |             ==> { AUTHORIAL_MODESTY_UO, - }
	dynamic memory allocation |     ==> { DYNAMIC_MEMORY_ALLOCATION_UO, - }
	memory economy |                ==> { MEMORY_ECONOMY_UO, - }
	no deprecated features |        ==> { NO_DEPRECATED_FEATURES_UO, - }
	numbered rules |                ==> { NUMBERED_RULES_UO, - }
	telemetry recordings |          ==> { TELEMETRY_RECORDING_UO, - }
	scoring |                       ==> { SCORING_UO, - }
	no scoring |                    ==> { NO_SCORING_UO, - }
	engineering notation |          ==> { ENGINEERING_NOTATION_UO, - }
	unabbreviated object names |    ==> { UNABBREVIATED_OBJECT_NAMES_UO, - }
	index figure thumbnails |       ==> { INDEX_FIGURE_THUMBNAILS_UO, - }
	undo prevention |               ==> { UNDO_PREVENTION_UO, - }
	serial comma |                  ==> { SERIAL_COMMA_UO, - }
	predictable randomisation |     ==> { PREDICTABLE_RANDOMISATION_UO, - }
	command line echoing |          ==> { COMMAND_LINE_ECHOING_UO, - }
	american dialect |              ==> { AMERICAN_DIALECT_UO, - }
	full-length room descriptions | ==> { FULL_LENGTH_ROOM_DESCRIPTIONS_UO, - }
	abbreviated room descriptions | ==> { ABBREVIATED_ROOM_DESCRIPTIONS_UO, - }
	verbose room descriptions |     ==> { VERBOSE_ROOM_DESCRIPTIONS_UO, - }
	brief room descriptions |       ==> { BRIEF_ROOM_DESCRIPTIONS_UO, - }
	superbrief room descriptions    ==> { SUPERBRIEF_ROOM_DESCRIPTIONS_UO, - }

@ Some of the pragma-like settings are stored here:

=
typedef struct compilation_settings {
	int allow_engineering_notation;
	int American_dialect;
	int command_line_echoing;
	int dynamic_memory_allocation;
	int index_figure_thumbnails;
	int memory_economy_in_force;
	int no_deprecated_features;
	int no_verb_verb_exists;
	int number_rules_in_index;
	int predictable_randomisation;
	int ranking_table_given;
	int room_description_level;
	int scoring_option_set;
	int serial_comma;
	int undo_prevention;
	int use_exact_parsing_option;
} compilation_settings;

compilation_settings global_compilation_settings;

@ Very early in compilation, the following is called:

=
void CompilationSettings::initialise_gcs(void) {
	global_compilation_settings.allow_engineering_notation = FALSE;
	global_compilation_settings.American_dialect = FALSE;
	global_compilation_settings.command_line_echoing = FALSE;
	global_compilation_settings.dynamic_memory_allocation = 0;
	global_compilation_settings.index_figure_thumbnails = 50;
	global_compilation_settings.memory_economy_in_force = FALSE;
	global_compilation_settings.no_deprecated_features = FALSE;
	global_compilation_settings.no_verb_verb_exists = FALSE;
	global_compilation_settings.number_rules_in_index = FALSE;
	global_compilation_settings.predictable_randomisation = FALSE;
	global_compilation_settings.ranking_table_given = FALSE;
	global_compilation_settings.room_description_level = 2;
	global_compilation_settings.scoring_option_set = NOT_APPLICABLE;
	global_compilation_settings.serial_comma = FALSE;
	global_compilation_settings.undo_prevention = FALSE;
	global_compilation_settings.use_exact_parsing_option = FALSE;
}

@ And when (for example) a "Use..." sentence triggers one of these, the
following function is called. (Note that this is not the only way that
the above settings can be changed.)

=
void CompilationSettings::set(int U, int N, source_file *from) {
	compilation_settings *g = &global_compilation_settings;
	switch (U) {
		case AUTHORIAL_MODESTY_UO: {
			inform_extension *E = Extensions::corresponding_to(from);
			if (E == NULL) Extensions::set_general_authorial_modesty();
			else Extensions::set_authorial_modesty(E);
			break;
		}
		case ABBREVIATED_ROOM_DESCRIPTIONS_UO: g->room_description_level = 3; break;
		case AMERICAN_DIALECT_UO:              g->American_dialect = TRUE; break;
		case BRIEF_ROOM_DESCRIPTIONS_UO:       g->room_description_level = 1; break;
		case COMMAND_LINE_ECHOING_UO:          g->command_line_echoing = TRUE; break;
		case ENGINEERING_NOTATION_UO:          g->allow_engineering_notation = TRUE; break;
		case FULL_LENGTH_ROOM_DESCRIPTIONS_UO: g->room_description_level = 2; break;
		case MEMORY_ECONOMY_UO:                g->memory_economy_in_force = TRUE; break;
		case NO_DEPRECATED_FEATURES_UO:        g->no_deprecated_features = TRUE; break;
		case NO_SCORING_UO:                    g->scoring_option_set = FALSE; break;
		case NUMBERED_RULES_UO:                g->number_rules_in_index = TRUE; break;
		case PREDICTABLE_RANDOMISATION_UO:     g->predictable_randomisation = TRUE; break;
		case SCORING_UO:                       g->scoring_option_set = TRUE; break;
		case SERIAL_COMMA_UO:                  g->serial_comma = TRUE; break;
		case SUPERBRIEF_ROOM_DESCRIPTIONS_UO:  g->room_description_level = 3; break;
		case TELEMETRY_RECORDING_UO:           ProblemBuffer::set_telemetry(); break;
		case UNABBREVIATED_OBJECT_NAMES_UO:    g->use_exact_parsing_option = TRUE; break;
		case UNDO_PREVENTION_UO:               g->undo_prevention = TRUE; break;
		case VERBOSE_ROOM_DESCRIPTIONS_UO:     g->room_description_level = 2; break;
	}
	if (N > 0) {
		switch (U) {
			case DYNAMIC_MEMORY_ALLOCATION_UO: g->dynamic_memory_allocation = N; break;
			case INDEX_FIGURE_THUMBNAILS_UO:   g->index_figure_thumbnails = N;   break;
		}
	}
}

@ Exact parsing in the //lexicon// module results from one such setting:

@d PARSE_EXACTLY_LEXICON_CALLBACK CompilationSettings::parse_exactly

=
int CompilationSettings::parse_exactly(excerpt_meaning *em) {
	if (em->meaning_code == NOUN_MC) {
		if (global_compilation_settings.use_exact_parsing_option) return TRUE;
		return FALSE;
	}
	return TRUE;
}
