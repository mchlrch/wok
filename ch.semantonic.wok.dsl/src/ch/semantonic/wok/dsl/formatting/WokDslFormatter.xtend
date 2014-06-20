/*******************************************************************************
 * Copyright (c) 2014 Michael Rauch
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Project: http://www.wok-lang.org
 *
 * Contributors:
 * Michael Rauch - initial API and implementation
 *******************************************************************************/
package ch.semantonic.wok.dsl.formatting

import ch.semantonic.wok.dsl.services.WokDslGrammarAccess
import com.google.inject.Inject
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
class WokDslFormatter extends AbstractDeclarativeFormatter {

	@Inject extension WokDslGrammarAccess

	override protected void configureFormatting(FormattingConfig c) {

		// It's usually a good idea to activate the following three statements.
		// They will add and preserve newlines around comments
		c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
		c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
		c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)

		// ImportDeclaration
		c.setNoSpace().before(importDeclarationAccess.semicolonKeyword_2);
		c.setLinewrap(1, 2, 2).after(importDeclarationAccess.semicolonKeyword_2);
		
		// AbstractElement
		c.setLinewrap(1, 2, 2).before(abstractElementRule);

		// Subject
		var subjectLeftCurlyBracket = subjectAccess.leftCurlyBracketKeyword_1;
		var subjectRightCurlyBracket = subjectAccess.rightCurlyBracketKeyword_3;
		c.setIndentationIncrement().after(subjectLeftCurlyBracket);
		c.setIndentationDecrement().before(subjectRightCurlyBracket);
		c.setLinewrap(0, 1, 2).after(subjectLeftCurlyBracket);
		c.setLinewrap(0, 1, 1).before(subjectRightCurlyBracket);
		c.setLinewrap(1, 1, 2).after(subjectRightCurlyBracket);

		// EmbeddedSubject
		c.setNoSpace().after(embeddedSubjectAccess.leftCurlyBracketKeyword_0);
		c.setNoSpace().before(embeddedSubjectAccess.rightCurlyBracketKeyword_2);

		// Feature
		c.setLinewrap(1, 1, 2).before(featureRule);

		// Attribute
		c.setNoSpace().before(attributeAccess.colonKeyword_0_1);

		// ReferencedSubject
		c.setNoSpace().before(referencedSubjectAccess.colonKeyword_0_1);
	}

}
