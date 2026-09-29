"
I am the ViewModel for the root OPBPMNModel, managing its UI representation and mapping its essential children (nodes and flows) into the diagram controllers.
"
Class {
	#name : 'OPBPMNModelViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNModelViewModel class >> commonModelClassPrefix [

	^ 'OPBPMN'
]

{ #category : 'accessing' }
OPBPMNModelViewModel class >> modelClass [ ^ OPBPMNModel
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> childrenModels [ ^ self model nodes
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> essentialChildrenModels [
	"Answers all model elements that must be visualized in diagram controllers, including pools, nested nodes, flows, and associations."
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
OPBPMNModelViewModel >> icon [ ^ OPBPMNIcon current logo
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> modelRootViewModel [

	^ self
]
