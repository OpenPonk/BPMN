Class {
	#name : #OPBPMNNodeController,
	#superclass : #OPElementController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNNodeController >> canBeSourceFor: aController [
	^ (aController isKindOf: OPBPMNEdgeController) and: [ self class ~= aController source class ]
]

{ #category : #connecting }
OPBPMNNodeController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBPMNEdgeController) and: [ self class ~= aController source class ]
]

{ #category : #connecting }
OPBPMNNodeController >> createRoassalShape [
	^ self subclassResponsibility
]

{ #category : #private }
OPBPMNNodeController >> isHideable [
	^ true
]

{ #category : #private }
OPBPMNNodeController >> removeModel [
	self diagramController model remove: self model
]

{ #category : #construction }
OPBPMNNodeController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure
		addInteraction:
			(OPRTMultilineLabeled new
				view: aView;
				below;
				color: Color black;
				yourself).
	figure @ RTDraggable.
	figure @ OPRTFocusable.
	figure renderIn: aView.
	^ self diagramController addedFigureFor: self
]
