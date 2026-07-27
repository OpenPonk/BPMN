Class {
	#name : 'OPBPMNAbstractFlowShape',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'reacting' }
OPBPMNAbstractFlowShape >> associationCreated: anAssociation [

	"do nothing"
]

{ #category : 'initialization' }
OPBPMNAbstractFlowShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	OPBPMNEdgeLabel in: self
]

{ #category : 'rendering' }
OPBPMNAbstractFlowShape >> renderBasicShape [

	^ OPRSPolyline new
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
