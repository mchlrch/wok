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
package ch.semantonic.wok.dsl;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class WokDslStandaloneSetup extends WokDslStandaloneSetupGenerated{

	public static void doSetup() {
		new WokDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

