Class {
	#name : 'OPBPMNFlowShape',
	#superclass : 'OPBPMNAbstractFlowShape',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'hooks' }
OPBPMNFlowShape >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: Color black;
		  yourself
]

{ #category : 'accessing' }
OPBPMNFlowShape >> strokeColor: aColor [

	self roassalShape color: aColor.
]

{ #category : 'hooks' }
OPBPMNFlowShape >> tailMarker [

	self modelElement ifNil: [ 
		^ (RSShapeFactory polygonWithPoints: (Array with: 0 @ 0))
			  color: Color black;
			  yourself ].
	self modelElement type = 'Normal' ifTrue: [ 
		^ (RSShapeFactory polygonWithPoints: (Array with: 0 @ 0))
			  color: Color black;
			  yourself ].
	self modelElement type = 'Conditional' ifTrue: [ 
		^ (RSShapeFactory polygonWithPoints: (Array
					    with: 0 @ 20
					    with: 6 @ 10
					    with: 0 @ 0
					    with: -6 @ 10))
			  color: Color black;
			  yourself ].
	self modelElement type = 'Default' ifTrue: [ 
		^ (RSShapeFactory polygonWithPoints:
				   (Array with: 6 @ 12 with: 6 @ 10 with: -6 @ 20 with: -6 @ 22 ))
			  color: Color black;
			  yourself ]
]

{ #category : 'rendering' }
OPBPMNFlowShape >> updateRenderFromModel [

	self roassalShape markerStart: self tailMarker.
	super updateRenderFromModel
]
