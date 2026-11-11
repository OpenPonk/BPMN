"
I am a unit test class verifying the creation, attachment, and diagram targeting behavior of OPBPMNActivityController.
"
Class {
	#name : 'OPBPMNActivityControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNActivityControllerTest class >> diagramElementClass [
	^ OPBPMNActivityShape
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> controllerClass [
	^ OPBPMNActivityController 
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> modelClass [
	^ OPBPMNActivityModel 
]

{ #category : 'tests' }
OPBPMNActivityControllerTest >> testIconPositionRemainsAtOffsetAfterUpdateRenderFromModel [
	| shape roassalCenter iconPos |
	self showInDiagram.
	self model type: OPBPMNNodeType Service.
	self controller modelChanged.
	shape := self controller diagramElement.
	roassalCenter := shape roassalShape position.
	iconPos := (shape instVarNamed: #icon) position.
	self
		assert: (iconPos x closeTo: roassalCenter x - 28)
		description: 'Activity icon X must be offset by -28 from center, but was ' , (iconPos x - roassalCenter x) asString.
	self
		assert: (iconPos y closeTo: roassalCenter y - 16)
		description: 'Activity icon Y must be offset by -16 from center, but was ' , (iconPos y - roassalCenter y) asString
]
