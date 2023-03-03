Class {
	#name : #OPBPMNDataFlowShape,
	#superclass : #OPEdge,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #rendering }
OPBPMNDataFlowShape >> renderBasicShape [

	^ (self source = self target
		   ifTrue: [ OPRSBezier ]
		   ifFalse: [ OPRSPolyline ]) new
		  withBorderAttachPoint;
		  dashed;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
