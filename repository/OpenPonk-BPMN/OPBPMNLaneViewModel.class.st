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

{ #category : 'forms' }
OPBPMNLaneViewModel >> buildEditorForm: aPropertiesForm [
	"Build dynamic properties form with single-line name input."
	aPropertiesForm bindTextInput: 'Name' property: #name
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
	targetLaneModel ifNotNil: [
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
