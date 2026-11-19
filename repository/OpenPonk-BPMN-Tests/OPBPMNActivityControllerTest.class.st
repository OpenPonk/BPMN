"
I am a unit test class verifying the creation, attachment, and diagram targeting behavior of OPBPMNActivityController.
"
Class {
	#name : 'OPBPMNActivityControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
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

	| shape hostRect iconRect |
	self showInDiagram.
	self model type: OPBPMNNodeType Service.
	self controller modelChanged.
	shape := self controller diagramElement.
	hostRect := shape roassalShape encompassingRectangle.
	iconRect := (shape instVarNamed: #icon) encompassingRectangle.
	self assert: iconRect left closeTo: hostRect left + 6 precision: 0.5.
	self assert: iconRect top closeTo: hostRect top + 5 precision: 0.5
]
