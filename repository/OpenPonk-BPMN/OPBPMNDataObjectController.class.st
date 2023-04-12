Class {
	#name : #OPBPMNDataObjectController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #testing }
OPBPMNDataObjectController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #DataObject #DataInput #DataOutput #DataStore);
		displayIcon: [ :type | self typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
]

{ #category : #testing }
OPBPMNDataObjectController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNDataFlowController
]

{ #category : #testing }
OPBPMNDataObjectController >> canBeTargetFor: aController [
	^ aController isKindOf: OPBPMNDataFlowController
]

{ #category : #testing }
OPBPMNDataObjectController >> dependentElements [
	^ (model incoming , model outgoing) asSet
]

{ #category : #testing }
OPBPMNDataObjectController >> diagramElementClass [

	^ OPBPMNDataObjectShape
]

{ #category : #testing }
OPBPMNDataObjectController >> modelClass [
	^ OPBPMNDataObjectModel
]

{ #category : #testing }
OPBPMNDataObjectController >> renderDiagramElement [

	super renderDiagramElement.
	model when: OPPlaceTokensChanged do: [ self diagramElement modelChanged ]
]

{ #category : #testing }
OPBPMNDataObjectController >> typeIconFor: aType [
	aType = OPBPMNNodeType DataObject
		ifTrue: [ ^ OPBPMNIcon current dataObject16 ].
	aType = OPBPMNNodeType DataInput
		ifTrue: [ ^ OPBPMNIcon current dataInput16 ].
	aType = OPBPMNNodeType DataOutput
		ifTrue: [ ^ OPBPMNIcon current dataOutput16 ].
	aType = OPBPMNNodeType DataStore
		ifTrue: [ ^ OPBPMNIcon current dataStore16 ].
]

{ #category : #testing }
OPBPMNDataObjectController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
