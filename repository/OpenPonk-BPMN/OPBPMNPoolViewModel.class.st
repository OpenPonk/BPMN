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
	super buildEditorForm: aForm.
	aForm bindNumberInput: 'Lanes' property: #lanes.
	1 to: self model lanes do: [ :laneIndex |
		aForm
			bindTextInput: 'Lane ' , laneIndex asString
			accessor: (MAPluggableAccessor
				read: [ :vm | vm model laneNameAt: laneIndex ]
				write: [ :vm :newValue |
					vm model laneNamesAt: laneIndex put: newValue asString.
					vm modelChanged ])
			description: nil ]
]

{ #category : 'undo/redo' }
OPBPMNPoolViewModel >> commandForProperty: aSymbol accessor: anAccessor oldValue: anOldValue newValue: aNewValue [
	"Intercept #lanes mutations to encapsulate the entire laneNames collection into a reversible command."
	aSymbol = #lanes ifTrue: [
		| oldNames newNames |
		oldNames := self model laneNames copy asOrderedCollection.
		newNames := self computeLaneNamesForCount: aNewValue.
		^ OPPropertyChangeCommand
			viewModel: self
			selector: #laneNames
			oldValue: oldNames
			newValue: newNames ].
	^ super commandForProperty: aSymbol accessor: anAccessor oldValue: anOldValue newValue: aNewValue
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> computeLaneNamesForCount: aNumber [
	"Answer an OrderedCollection of lane names adjusted to the requested count, appending default names when expanding."
	| count currentNames newNames |
	count := (aNumber asInteger ifNil: [ 0 ]) max: 0.
	currentNames := self model laneNames.
	count < currentNames size ifTrue: [
		^ (currentNames copyFrom: 1 to: count) asOrderedCollection ].
	newNames := currentNames copy asOrderedCollection.
	currentNames size + 1 to: count do: [ :i |
		newNames add: 'Lane ' , i asString ].
	^ newNames
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> essentialChildrenModels [
	"Answers all nodes and edges belonging directly or transitively to this pool."
	| collectedNodes collectedEdges |
	collectedNodes := Set new.
	collectedEdges := Set new.
	
	self model allElements do: [ :eachModelElement |
		eachModelElement isNode ifTrue: [
			collectedNodes add: eachModelElement.
			collectedEdges addAll: eachModelElement edges ].
		eachModelElement isEdge ifTrue: [
			collectedEdges add: eachModelElement ] ].
			
	^ (collectedNodes asArray , collectedEdges asArray) asSet asArray
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> icon [ ^ OPBPMNIcon current pool
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> structuralPropertySelectors [
	"Answer selectors whose changes structurally alter the editor form."
	^ #( #lanes #laneNames )
]
