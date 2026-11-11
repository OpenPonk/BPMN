"
I am a unit test class verifying the creation, canvas rendering, and valid connection targeting of OPBPMNCollapsedSubProcessController.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
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
	| shape roassalCenter iconPos subprocessIconPos |
	self showInDiagram.
	self model type: OPBPMNNodeType MarkerParallel.
	self controller modelChanged.
	shape := self controller diagramElement.
	roassalCenter := shape roassalShape position.
	iconPos := (shape instVarNamed: #icon) position.
	subprocessIconPos := (shape instVarNamed: #subprocessIcon) position.
	self
		assert: (iconPos x closeTo: roassalCenter x - 16)
		description: 'Marker icon X must be offset by -16 from center, but was ' , (iconPos x - roassalCenter x) asString.
	self
		assert: (iconPos y closeTo: roassalCenter y + 16)
		description: 'Marker icon Y must be offset by +16 from center, but was ' , (iconPos y - roassalCenter y) asString.
	self
		assert: (subprocessIconPos x closeTo: roassalCenter x)
		description: 'Subprocess [+] icon X must be aligned with center, but was ' , (subprocessIconPos x - roassalCenter x) asString.
	self
		assert: (subprocessIconPos y closeTo: roassalCenter y + 16)
		description: 'Subprocess [+] icon Y must be offset by +16 from center, but was ' , (subprocessIconPos y - roassalCenter y) asString
]
