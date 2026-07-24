Class {
	#name : 'OPBPMNDataFlowShape',
	#superclass : 'OPEdge',
	#instVars : [
		'borderColor'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPBPMNDataFlowShape >> borderColor [

	^ borderColor
]

{ #category : 'rendering' }
OPBPMNDataFlowShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	OPBPMNEdgeLabel in: self
]

{ #category : 'rendering' }
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

{ #category : 'rendering' }
OPBPMNDataFlowShape >> strokeColor: aColor [

	borderColor := aColor
]
