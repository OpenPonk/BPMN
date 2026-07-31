Class {
	#name : 'OPBPMNPoolControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNPoolControllerTest >> controllerClass [
	^ OPBPMNPoolController 
]

{ #category : 'constants' }
OPBPMNPoolControllerTest >> diagramElementClass [
	^ OPBPMNPoolShape
]

{ #category : 'constants' }
OPBPMNPoolControllerTest >> modelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testAssignmentToParent [
	"not by pool"
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testFigureRefresh [

	| text |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	self assert: controller diagramElement nameLabel text equals: ''.
	controller model name: 'new name'.
	controller modelChanged.
	text := controller diagramElement nameLabel text.
	self assert:
		((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]
