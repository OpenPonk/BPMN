Class {
	#name : #OPBPMNBoundaryEventTest,
	#superclass : #OPBPMNNodeControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNBoundaryEventTest >> controllerClass [
	^ OPBPMNBoundaryEventController 
]

{ #category : #accessing }
OPBPMNBoundaryEventTest >> diagramElementClass [
	^ OPBPMNBoundaryEventShape 
]

{ #category : #accessing }
OPBPMNBoundaryEventTest >> modelClass [
	^ OPBPMNBoundaryEventModel 
]

{ #category : #accessing }
OPBPMNBoundaryEventTest >> targetControllerClass [
	^ OPBPMNSubProcessController 
]

{ #category : #accessing }
OPBPMNBoundaryEventTest >> targetModelClass [
	^ OPBPMNSubProcessModel  
]

{ #category : #accessing }
OPBPMNBoundaryEventTest >> testCannotConnectByDefault [
	controller model: model.
	self deny: (controller canBeSourceFor: nil)
]
