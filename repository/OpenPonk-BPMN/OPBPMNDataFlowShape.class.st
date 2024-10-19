Class {
	#name : 'OPBPMNDataFlowShape',
	#superclass : 'OPEdge',
	#instVars : [
		'borderColor'
	],
	#category : 'OpenPonk-BPMN-Shapes',
	#package : 'OpenPonk-BPMN',
	#tag : 'Shapes'
}

{ #category : 'rendering' }
OPBPMNDataFlowShape >> borderColor [

	^ borderColor
]

{ #category : 'rendering' }
OPBPMNDataFlowShape >> borderColor: aColor [

	borderColor := aColor
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
