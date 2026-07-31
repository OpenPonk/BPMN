Class {
	#name : 'OPBPMNBoundaryEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
OPBPMNBoundaryEventControllerTest >> diagramElementClass [
	^ OPBPMNBoundaryEventShape 
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
