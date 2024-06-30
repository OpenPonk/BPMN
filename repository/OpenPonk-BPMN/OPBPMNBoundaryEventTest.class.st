Class {
	#name : 'OPBPMNBoundaryEventTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNBoundaryEventTest >> controllerClass [
	^ OPBPMNBoundaryEventController 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventTest >> creationTargetControllerClass [
	^ OPBPMNSubProcessController 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventTest >> creationTargetModelClass [
	^ OPBPMNSubProcessModel  
]

{ #category : 'accessing' }
OPBPMNBoundaryEventTest >> diagramElementClass [
	^ OPBPMNBoundaryEventShape 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventTest >> modelClass [
	^ OPBPMNBoundaryEventModel 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventTest >> testCannotConnectByDefault [
	controller model: model.
	self deny: (controller canBeSourceFor: nil)
]
