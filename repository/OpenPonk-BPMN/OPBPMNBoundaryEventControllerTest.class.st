"
I am a unit test class verifying the behavior of OPBPMNBoundaryEventController, focusing on its valid attachment constraints to host activity shapes.
"
Class {
	#name : 'OPBPMNBoundaryEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNBoundaryEventControllerTest class >> diagramElementClass [
	^ OPBPMNBoundaryEventShape 
]

{ #category : 'constants' }
OPBPMNBoundaryEventControllerTest >> controllerClass [
	^ OPBPMNBoundaryEventController 
]

{ #category : 'constants' }
OPBPMNBoundaryEventControllerTest >> creationTargetControllerClass [
	^ OPBPMNSubProcessController 
]

{ #category : 'constants' }
OPBPMNBoundaryEventControllerTest >> creationTargetModelClass [
	^ OPBPMNSubProcessModel  
]

{ #category : 'constants' }
OPBPMNBoundaryEventControllerTest >> modelClass [
	^ OPBPMNBoundaryEventModel 
]

{ #category : 'tests' }
OPBPMNBoundaryEventControllerTest >> testCannotConnectByDefault [

	controller model: model.
	self deny: (controller canBeSourceFor: nil)
]
