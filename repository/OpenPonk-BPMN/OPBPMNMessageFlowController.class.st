Class {
	#name : #OPBPMNMessageFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #construction }
OPBPMNMessageFlowController >> diagramElementClass [

	^ OPBPMNMessageShape
]

{ #category : #hooks }
OPBPMNMessageFlowController >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: Color black;
		  yourself
]

{ #category : #hooks }
OPBPMNMessageFlowController >> modelClass [
	^ OPBPMNMessageFlowModel
]
