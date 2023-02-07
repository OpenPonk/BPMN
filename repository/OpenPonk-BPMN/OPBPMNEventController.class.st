Class {
	#name : #OPBPMNEventController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNEventController >> createRoassalShape [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNEventController >> modelClass [
	^ self subclassResponsibility
]

{ #category : #construction }
OPBPMNEventController >> renderFigureIn: aView [
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
	iconElement := (RTBitmap new form: self typeIconForModel) element.
	iconConstraint := (RTConstraint on: iconElement background: figure)
		center;
		stick.
	iconElement renderIn: aView.
	figure addCallback: (TRRemoveCallback with: iconElement).
	self saveStateOnDragEndFor: figure.
	^ self diagramController addedFigureFor: self
]

{ #category : #hooks }
OPBPMNEventController >> typeIconForModel [
	^ self typeIconFor: self model type
]
