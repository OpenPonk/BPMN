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
