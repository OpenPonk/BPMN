Class {
	#name : #OPBPMNFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNFlowController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Normal #Default #Conditional );
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
]

{ #category : #accessing }
OPBPMNFlowController >> diagramElementClass [

	^ OPBPMNFlowShape
]

{ #category : #accessing }
OPBPMNFlowController >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: Color black;
		  yourself
]

{ #category : #accessing }
OPBPMNFlowController >> modelClass [
	^ OPBPMNFlowModel
]
