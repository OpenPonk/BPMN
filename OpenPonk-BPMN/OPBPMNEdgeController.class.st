Class {
	#name : #OPBPMNEdgeController,
	#superclass : #OPDirectionalRelationshipController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #hooks }
OPBPMNEdgeController >> createEdgeFrom: fromElement to: toElement [
	^ OPRTStyledMultiLine new
		head: self headShapeClass;
		withBorderAttachPoint;
		color: Color black;
		edgeFrom: fromElement to: toElement
]

{ #category : #private }
OPBPMNEdgeController >> removeModel [
	self diagramController model remove: self model
]

{ #category : #construction }
OPBPMNEdgeController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := self
		createEdgeFrom: self source figure
		to: self target figure.
	figure renderIn: aView.
	self addLabels.
	^ self diagramController addedFigureFor: self
]
