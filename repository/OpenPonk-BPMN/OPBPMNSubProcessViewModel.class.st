"
I map the underlying BPMN SubProcess model to its UI representation, manage its property forms, and expose its contained child elements.
"
Class {
	#name : 'OPBPMNSubProcessViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNSubProcessViewModel class >> modelClass [ ^ OPBPMNSubProcessModel
]

{ #category : 'forms' }
OPBPMNSubProcessViewModel >> buildEditorForm: aForm [
	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Marker'
		property: #type
		items:
			#( #None #MarkerParallel #MarkerSequential #MarkerLoop #MarkerCompensation
			   #MarkerAdhoc ).
	droplist displayIcon: [ :eachMarker | self typeIconFor: eachMarker ].
	droplist display: [ :eachMarker | eachMarker asString ]
]

{ #category : 'accessing' }
OPBPMNSubProcessViewModel >> essentialChildrenModels [
	"Answers all nodes and edges belonging directly or transitively to this subprocess."
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
OPBPMNSubProcessViewModel >> icon [ ^ OPBPMNIcon current expandedSubprocess
]

{ #category : 'testing' }
OPBPMNSubProcessViewModel >> isNameMultiline [
	^ true
]

{ #category : 'forms' }
OPBPMNSubProcessViewModel >> typeIconFor: aType [
	aType = OPBPMNNodeType None ifTrue: [
		^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType MarkerParallel ifTrue: [
		^ OPBPMNIcon current markerParallel ].
	aType = OPBPMNNodeType MarkerSequential ifTrue: [
		^ OPBPMNIcon current markerSequential ].
	aType = OPBPMNNodeType MarkerLoop ifTrue: [
		^ OPBPMNIcon current markerLoop ].
	aType = OPBPMNNodeType MarkerCompensation ifTrue: [
		^ OPBPMNIcon current markerCompensation ].
	aType = OPBPMNNodeType MarkerAdhoc ifTrue: [
		^ OPBPMNIcon current markerAdhoc ].
	^ super typeIconFor: aType
]
