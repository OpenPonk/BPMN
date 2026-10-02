Class {
	#name : 'OPBPMNLaneViewModel',
	#superclass : 'OPModelObjectViewModel',
	#instVars : [
		'targetLaneModel',
		'insertBefore'
	],
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNLaneViewModel class >> modelClass [
	"Answer the domain model class mapped by this view model."
	^ OPBPMNLaneModel
]

{ #category : 'removing' }
OPBPMNLaneViewModel >> basicRemoveModel [
	self captureLanePosition.
	super basicRemoveModel
]

{ #category : 'forms' }
OPBPMNLaneViewModel >> buildEditorForm: aPropertiesForm [
	"Build dynamic properties form with single-line name input."
	aPropertiesForm bindTextInput: 'Name' property: #name
]

{ #category : 'private' }
OPBPMNLaneViewModel >> captureLanePosition [
	| parent lanes myIndex |
	parent := self parentContainerModel.
	parent ifNil: [ ^ self ].
	lanes := parent lanes.
	myIndex := lanes indexOf: self model.
	myIndex = 0 ifTrue: [ ^ self ].
	myIndex < lanes size
		ifTrue: [
			targetLaneModel := lanes at: myIndex + 1.
			insertBefore := true ]
		ifFalse: [
			myIndex > 1
				ifTrue: [
					targetLaneModel := lanes at: myIndex - 1.
					insertBefore := false ]
				ifFalse: [
					targetLaneModel := nil ] ]
]

{ #category : 'accessing' }
OPBPMNLaneViewModel >> icon [
	"Answer the 27x16 BPMN lane icon."
	^ OPBPMNIcon current lane
]

{ #category : 'accessing' }
OPBPMNLaneViewModel >> insertBefore [
	^ insertBefore ifNil: [ false ]
]

{ #category : 'accessing' }
OPBPMNLaneViewModel >> insertBefore: aBoolean [
	insertBefore := aBoolean
]

{ #category : 'registering' }
OPBPMNLaneViewModel >> registerModelIn: aParentModel [
	(targetLaneModel isNotNil and: [ aParentModel elements includes: targetLaneModel ]) ifTrue: [
		^ self insertBefore
			ifTrue: [ aParentModel addLane: self model before: targetLaneModel ]
			ifFalse: [ aParentModel addLane: self model after: targetLaneModel ] ].
	^ aParentModel addLane: self model
]

{ #category : 'accessing' }
OPBPMNLaneViewModel >> targetLaneModel [
	^ targetLaneModel
]

{ #category : 'accessing' }
OPBPMNLaneViewModel >> targetLaneModel: aLaneModel [
	targetLaneModel := aLaneModel
]
