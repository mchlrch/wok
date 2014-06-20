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
package ch.semantonic.wok.dsl.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;

/**
 * Use this class to register components to be used within the IDE.
 */
public class WokDslUiModule extends ch.semantonic.wok.dsl.ui.AbstractWokDslUiModule {
	public WokDslUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}
}
