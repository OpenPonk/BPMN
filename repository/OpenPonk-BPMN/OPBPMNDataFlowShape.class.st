"
I render a BPMN Data Association flow, drawing the directed path between data objects and activities.
"
Class {
	#name : 'OPBPMNDataFlowShape',
	#superclass : 'OPBPMNAbstractFlowShape',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPBPMNDataFlowShape >> renderBasicShape [

	^ super renderBasicShape
		  dashed;
		  yourself
]
