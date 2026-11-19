"
I am a unit test class verifying the creation, canvas rendering, and valid connection targeting of OPBPMNCollapsedSubProcessController.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest class >> diagramElementClass [
	^ OPBPMNCollapsedSubProcessShape 
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> controllerClass [
	^ OPBPMNCollapsedSubProcessController  
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> modelClass [
	^ OPBPMNCollapsedSubProcessModel 
]

{ #category : 'tests' }
OPBPMNCollapsedSubProcessControllerTest >> testIconPositionsRemainAtOffsetsAfterUpdateRenderFromModel [

	| shape hostRect iconRect subprocessIconRect |
	self showInDiagram.
	self model type: OPBPMNNodeType MarkerParallel.
	self controller modelChanged.
	shape := self controller diagramElement.
	hostRect := shape roassalShape encompassingRectangle.
	iconRect := (shape instVarNamed: #icon) encompassingRectangle.
	subprocessIconRect := (shape instVarNamed: #subprocessIcon) encompassingRectangle.
	self assert: iconRect floatCenter x closeTo: hostRect floatCenter x - 18 precision: 0.5.
	self assert: iconRect bottom closeTo: hostRect bottom - 4 precision: 0.5.
	self assert: subprocessIconRect floatCenter x closeTo: hostRect floatCenter x precision: 0.5.
	self assert: subprocessIconRect bottom closeTo: hostRect bottom - 4 precision: 0.5
]
