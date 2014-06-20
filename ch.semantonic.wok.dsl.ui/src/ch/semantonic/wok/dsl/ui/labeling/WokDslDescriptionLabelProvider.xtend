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
package ch.semantonic.wok.dsl.ui.labeling

//import org.eclipse.xtext.resource.IEObjectDescription

/**
 * Provides labels for a IEObjectDescriptions and IResourceDescriptions.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class WokDslDescriptionLabelProvider extends org.eclipse.xtext.ui.label.DefaultDescriptionLabelProvider {

	// Labels and icons can be computed like this:
	
//	override text(IEObjectDescription ele) {
//		ele.name.toString
//	}
//	 
//	override image(IEObjectDescription ele) {
//		ele.EClass.name + '.gif'
//	}	 
}
