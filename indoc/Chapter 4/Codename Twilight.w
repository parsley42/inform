[Twilight::] Codename Twilight.

The "twilight" style of navigational gadgets, a minimal version
of "midnight".

@h Creation.

=
navigation_design *Twilight::create(void) {
	navigation_design *ND = Nav::new(I"twilight", FALSE, FALSE);
	ND->simplified_examples = TRUE;
	ND->simplified_letter_rows = TRUE;
	METHOD_ADD(ND, RENDER_CHAPTER_TITLE_MTID, Twilight::twilight_chapter_title);
	METHOD_ADD(ND, RENDER_SECTION_TITLE_MTID, Twilight::twilight_section_title);
	METHOD_ADD(ND, RENDER_INDEX_TOP_MTID, Twilight::twilight_navigation_index_top);
	METHOD_ADD(ND, RENDER_NAV_MIDDLE_MTID, Twilight::twilight_navigation_middle);
	METHOD_ADD(ND, RENDER_NAV_BOTTOM_MTID, Twilight::twilight_navigation_bottom);
	METHOD_ADD(ND, RENDER_CONTENTS_MTID, Twilight::twilight_navigation_contents_files);
	METHOD_ADD(ND, RENDER_CONTENTS_HEADING_MTID, Twilight::twilight_navigation_contents_heading);
	return ND;
}

@h Top.
At the front end of a section, before any of its text.

=
void Twilight::twilight_chapter_title(navigation_design *self, text_stream *OUT, volume *V, chapter *C) {
	HTML_OPEN("h2");
	WRITE("%S", C->chapter_full_title);
	HTML_CLOSE("h2");
}

@ =
void Twilight::twilight_section_title(navigation_design *self, text_stream *OUT, volume *V, chapter *C, section *S) {
	HTML::begin_div_with_class_S(OUT, I"bookheader");
	HTML_OPEN_WITH("table", "width=\"100%%\"");
	HTML_OPEN("tr");
	HTML_OPEN_WITH("td", "width=80 valign=\"top\"");
	if (S->previous_section) {
		TEMPORARY_TEXT(img)
		HTMLUtilities::image_element(img, I"Back.png");
		HTMLUtilities::general_link(OUT, I"standardlink", S->previous_section->section_URL, img);
		DISCARD_TEXT(img)
	} else {
		HTMLUtilities::image_element(OUT, I"BackDisabled.png");
	}
	TEMPORARY_TEXT(url)
	TEMPORARY_TEXT(img)
	WRITE_TO(url, "%S.html", indoc_settings->contents_leafname);
	HTMLUtilities::image_element(img, I"Home.png");
	HTMLUtilities::general_link(OUT, I"standardlink", url, img);
	DISCARD_TEXT(img)
	DISCARD_TEXT(url)
	if (S->next_section) {
		TEMPORARY_TEXT(img)
		HTMLUtilities::image_element(img, I"Forward.png");
		HTMLUtilities::general_link(OUT, I"standardlink", S->next_section->section_URL, img);
		DISCARD_TEXT(img)
	} else {
		HTMLUtilities::image_element(OUT, I"ForwardDisabled.png");
	}
	HTML_CLOSE("td");
	HTML_CLOSE("tr");
	HTML_CLOSE("table");
	HTML::end_div(OUT);

	HTML_OPEN_WITH("p", "class=\"sectionheading\"");
	if (Str::len(S->section_anchor) > 0) HTML::anchor(OUT, S->section_anchor);
	WRITE("%c%S", SECTION_SYMBOL, S->title);
	HTML_CLOSE("p");
}

@h Index top.
And this is a variant for index pages, such as the index of examples.

=
void Twilight::twilight_navigation_index_top(navigation_design *self, text_stream *OUT, text_stream *filename, text_stream *title) {
	HTML_OPEN("h2");
	WRITE("%S", title);
	HTML_CLOSE("h2");
}

@h Middle.
At the middle part, when the text is over, but before any example cues.

=
void Twilight::twilight_navigation_middle(navigation_design *self, text_stream *OUT, volume *V, section *S) {
	HTMLUtilities::ruled_line(OUT);
}

@h Bottom.
At the end of the section, after any example cues and perhaps also example
bodied. (In a section with no examples, this immediately follows the middle.)

=
void Twilight::twilight_navigation_bottom(navigation_design *self, text_stream *OUT, volume *V, section *S) {
	HTML::begin_div_with_class_S(OUT, I"bookfooter");
	HTML_OPEN("p");
	if (S->previous_section) {
		HTMLUtilities::general_link(OUT, I"footerlink", S->previous_section->section_URL, I"Previous");
		WRITE(" / ");
	}
	if (S->next_section) {
		HTMLUtilities::general_link(OUT, I"footerlink", S->next_section->section_URL, I"Next");
		WRITE(" / ");
	}
	TEMPORARY_TEXT(url)
	WRITE_TO(url, "%S.html", indoc_settings->contents_leafname);
	HTMLUtilities::general_link(OUT, I"footerlink", url, I"Contents");
	DISCARD_TEXT(url)
	HTML_CLOSE("p");
	HTML::end_div(OUT);
}

@h Contents page.
Twilight provides a contents page of its very own: actually, several.

=
void Twilight::twilight_navigation_contents_files(navigation_design *self) {
	volume *V;
	LOOP_OVER(V, volume)
		Midnight::write_contents_page(self, V);
}

void Twilight::twilight_navigation_contents_heading(navigation_design *self, text_stream *OUT, volume *V) {
	HTML_OPEN("h2");
	WRITE("%S", V->vol_title);
	HTML_CLOSE("h2");
}
