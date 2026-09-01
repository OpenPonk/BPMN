"
I am a unit test class verifying the behavior of OPBPMNDataFlowController, focusing on correct source and target assignments for data associations.
"
Class {
	#name : 'OPBPMNDataFlowControllerTest',
	#superclass : 'OPBPMNAbstractFlowControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNDataFlowControllerTest class >> diagramElementClass [

	^ OPBPMNDataFlowShape 
]

{ #category : 'constants' }
OPBPMNDataFlowControllerTest >> controllerClass [
	^ OPBPMNDataFlowController
]

{ #category : 'constants' }
OPBPMNDataFlowControllerTest >> modelClass [
	^ OPBPMNDataFlowModel 
]

{ #category : 'constants' }
OPBPMNDataFlowControllerTest >> sourceControllerClass [
	^ OPBPMNDataObjectController  
]

{ #category : 'constants' }
OPBPMNDataFlowControllerTest >> sourceModelClass [
	^ OPBPMNDataObjectModel 
]
