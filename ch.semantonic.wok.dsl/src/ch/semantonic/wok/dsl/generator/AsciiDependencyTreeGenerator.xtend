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
package ch.semantonic.wok.dsl.generator

import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.Box
import ch.semantonic.wok.dsl.wokDsl.ContainedBoxItem
import ch.semantonic.wok.dsl.wokDsl.DslRoot
import java.util.LinkedList
import java.util.List
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

class AsciiDependencyTreeGenerator implements IGenerator {

	enum NodeType {Node, LastNode}

	val String PREFIX_NODE = "├──";
	val String PREFIX_LASTNODE = "└──";


	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val uri = resource.URI
		val fileName = uri.segmentsList.last + '_' + uri.hashCode + '_boxen.txt'

		val sb = new StringBuffer(".\n");
		resource.contents
			.filter(typeof(DslRoot))			
			.forEach[dslModel |
				appendSubtrees(dslModel.elements.filter(typeof(Box)), emptyList, sb)
			];
		
		fsa.generateFile(fileName, sb);
	}

	def void appendSubtrees(Iterable<Box> boxen, List<AsciiDependencyTreeGenerator.NodeType> pathFromRoot, StringBuffer sb) {
		boxen.forEach[box |
			val AsciiDependencyTreeGenerator.NodeType typeOfChild = if (box == boxen.last) AsciiDependencyTreeGenerator.NodeType.LastNode else AsciiDependencyTreeGenerator.NodeType.Node;
			val List<AsciiDependencyTreeGenerator.NodeType> pathFromRootToChild = new LinkedList(pathFromRoot); pathFromRootToChild.add(typeOfChild);
			appendSubtree(box, pathFromRootToChild, sb);
		]
	}

	def void appendSubtree(Box box, List<AsciiDependencyTreeGenerator.NodeType> pathFromRoot, StringBuffer sb) {
		sb.append(ident(pathFromRoot));
		sb.append(String.format("%s %s\n", if (pathFromRoot.last == AsciiDependencyTreeGenerator.NodeType.LastNode) PREFIX_LASTNODE else PREFIX_NODE, box.name));

		// recurse into child boxen
		if (box instanceof BasicBox) {
			val basicBox = box as BasicBox;
			appendSubtrees(basicBox.items.filter(typeof(ContainedBoxItem)).map[value], pathFromRoot, sb);
		}
	}
	
	def String ident(List<AsciiDependencyTreeGenerator.NodeType> pathFromRoot) {
		val sb = new StringBuilder;
		pathFromRoot.clone.reverse.tail.toList.reverse.forEach[node |
			sb.append(if (node == AsciiDependencyTreeGenerator.NodeType.Node) "|   " else "    ");
		]
		return sb.toString
	}
}

