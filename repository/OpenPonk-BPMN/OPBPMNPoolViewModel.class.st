"
I map the underlying BPMN Pool model to its UI representation. I build Magritte property forms for configuring pool and lane structures.
"
Class {
	#name : 'OPBPMNPoolViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNPoolViewModel class >> modelClass [ ^ OPBPMNPoolModel
]

{ #category : 'forms' }
OPBPMNPoolViewModel >> buildEditorForm: aForm [

	| amountOfShownLanes lanesInput |
	super buildEditorForm: aForm.

	"IMPORTANT: Lanes need to be last items in the form as only last items can be removed"

	amountOfShownLanes := 0.

	(lanesInput := aForm addNumberInput: 'Lanes')
		minimum: 0;
		text: self model lanes asString;
		whenTextChangedDo: [ :newValue |
				self model lanes: ((newValue asInteger ifNil: [ 0 ]) max: 0).
				amountOfShownLanes = self model lanes ifFalse: [
							amountOfShownLanes := self
								                      rebuildLaneNamesFrom: amountOfShownLanes
								                      inForm: aForm.
							aForm rebuildWidget ].
				self modelChanged ].

	amountOfShownLanes := self rebuildLaneNamesFrom: 0 inForm: aForm
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> essentialChildrenModels [

	^ self model nodes asArray
	  , (self model nodes flatCollect: [ :each | each outgoing ]) asArray
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> icon [ ^ OPBPMNIcon current pool
]

{ #category : 'forms' }
OPBPMNPoolViewModel >> rebuildLaneNamesFrom: amountOfShownLanes inForm: aForm [

	aForm removeLast: amountOfShownLanes - self model lanes * 2.

	self model laneNames withIndexDo: [ :eachLaneName :eachIndex |
			eachIndex > amountOfShownLanes ifTrue: [
					(aForm addTextInput: 'Lane ' , eachIndex asString)
						text: eachLaneName;
						whenTextChangedDo: [ :newValue |
								self model laneNamesAt: eachIndex put: newValue.
								self modelChanged ] ] ].

	^ self model lanes
]
