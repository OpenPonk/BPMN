Class {
	#name : 'OPBPMNMessageFlowShape',
	#superclass : 'OPBPMNAbstractFlowShape',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'hooks' }
OPBPMNMessageFlowShape >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: (Color transparent);
		  yourself
]

{ #category : 'rendering' }
OPBPMNMessageFlowShape >> renderBasicShape [

	^ super renderBasicShape
		  markerStart: self tailMarker;
		  markerEnd: self headMarker;
		  dashed;
		  yourself
]

{ #category : 'accessing' }
OPBPMNMessageFlowShape >> strokeColor: aColor [

	self roassalShape color: aColor
]

{ #category : 'hooks' }
OPBPMNMessageFlowShape >> tailMarker [

	^ RSCircle new
		  size: 8;
		  border: (RSBorder new
				   color: (Color black);
				   width: 1);
		  color: (Color white);
		  yourself
]
