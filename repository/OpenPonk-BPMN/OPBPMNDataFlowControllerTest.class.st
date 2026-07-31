Class {
	#name : 'OPBPMNDataFlowControllerTest',
	#superclass : 'OPBPMNAbstractFlowControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNDataFlowControllerTest >> controllerClass [
	^ OPBPMNDataFlowController
]

{ #category : 'constants' }
OPBPMNDataFlowControllerTest >> diagramElementClass [

	^ OPBPMNDataFlowShape 
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
