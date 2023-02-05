Class {
	#name : #OPBPMNNodeController,
	#superclass : #OPElementController,
	#classInstVars : [
		'PossibleOutgoing'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNNodeController >> addAsTargetFor: aController [
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController
		createModelIn: self model
		andShowInDiagram: self diagramController
]

{ #category : #connecting }
OPBPMNNodeController >> buildEditorForm: aForm [
	(aForm addText: 'Name')
		text: self model name;
		whenTextChangedDo: [ :newValue | 
			self model name: newValue asString.
			self diagramElement updateRenderFromModel ]
]

{ #category : #connecting }
OPBPMNNodeController >> createRoassalShape [
	^ self subclassResponsibility
]

{ #category : #private }
OPBPMNNodeController >> internalSubscribeTo: aModel [
	super internalSubscribeTo: aModel.
	aModel when: OPElementRemoved do: [ :e | self removeController ]
]

{ #category : #private }
OPBPMNNodeController >> isHideable [
	^ true
]

{ #category : #connecting }
OPBPMNNodeController >> layout [
	^ OPElementLayout
		withPosition: self figure position
		extent: self figure extent
]

{ #category : #connecting }
OPBPMNNodeController >> modelAsParent [
	^ self model owner
]

{ #category : #private }
OPBPMNNodeController >> modelClass [
	^ self subclassResponsibility
]

{ #category : #private }
OPBPMNNodeController >> removeModel [
	self model announcer unsubscribe: self.
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

{ #category : #connecting }
OPBPMNNodeController >> showSelectionFeedback [
	super showSelectionFeedback.
	self figure view signalUpdate
]
