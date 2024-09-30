"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestOpenPonkBPMN',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-BPMN-Manifest',
	#package : 'OpenPonk-BPMN',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkBPMN class >> ruleCollectionMessagesToExternalObjectRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPBPMNNodeController #removeModel #false)) #'2024-05-30T12:30:45.597+02:00') )
]
