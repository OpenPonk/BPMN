Class {
	#name : #OPBPMNIntermediateEventController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'innerCircle',
		'elements',
		'innerConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> createRoassalShape [
	^ RTRoundedBox new
		size: 36;
		borderRadius: 18;
		borderWidth: 1;
		color: Color transparent;
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> modelClass [
	^ OPBPMNIntermediateEventModel
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	innerConstraint move.
	figure trachelShape pushBack.
	self diagramController view signalUpdate.
	^ super refreshFigure
]

{ #category : #construction }
OPBPMNIntermediateEventController >> renderFigureIn: aView [
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
	innerCircle := RTRoundedBox new
		size: 28;
		borderRadius: 14;
		borderWidth: 1;
		color: Color transparent;
		borderColor: Color black;
		element.
	innerConstraint := (RTConstraint on: innerCircle background: figure)
		stick.
	innerCircle renderIn: aView.
	figure addCallback: (TRRemoveCallback with: innerCircle).
	self saveStateOnDragEndFor: figure.
	^ self diagramController addedFigureFor: self
]
