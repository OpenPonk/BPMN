Class {
	#name : #OPBPMNNodeController,
	#superclass : #OPElementController,
	#instVars : [
		'ownerParticipant'
	],
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
		whenTextIsAccepted: [ :newValue | 
			self model name: newValue asString.
			self refreshFigure ]
]

{ #category : #connecting }
OPBPMNNodeController >> createRoassalShape [
	^ self subclassResponsibility
]

{ #category : #private }
OPBPMNNodeController >> dependentElements [
	^ (model incoming , model outgoing) asSet
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

{ #category : #accessing }
OPBPMNNodeController >> ownerParticipant [
	^ ownerParticipant
]

{ #category : #accessing }
OPBPMNNodeController >> ownerParticipant: aParticipantController [
	ownerParticipant := aParticipantController
]

{ #category : #connecting }
OPBPMNNodeController >> refreshFigure [
	figure update.
	^ super refreshFigure
]

{ #category : #connecting }
OPBPMNNodeController >> removeFigure [
	super removeFigure
	"TODO vymazat z kolekce elements"
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

{ #category : #construction }
OPBPMNNodeController >> showInDiagram: aDiagramController [
	super showInDiagram: aDiagramController.
	self
		ownerParticipant:
			(aDiagramController
				controllerForModel:
					(aDiagramController model flows
						detect: [ :any | any elements includes: model ]))
]

{ #category : #connecting }
OPBPMNNodeController >> showSelectionFeedback [
	super showSelectionFeedback.
	self figure view signalUpdate
]
