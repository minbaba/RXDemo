//
//  RefreshIndicator.swift
//
//  Code generated using QuartzCode 1.39.17 on 16/8/5.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable
class RefreshIndicator: UIView {
	
	var layers : Dictionary<String, AnyObject> = [:]
	var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
	var updateLayerValueForCompletedAnimation : Bool = false
	
	
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	func setupProperties(){
		
	}
	
	func setupLayers(){
		self.backgroundColor = UIColor(red:1, green: 1, blue:1, alpha:0)
		
		let indicator = CALayer()
		indicator.frame = CGRectMake(0, -0, 30, 30)
		self.layer.addSublayer(indicator)
		layers["刷新_icon_indicator"] = indicator
		
		let arrow = CALayer()
		arrow.frame = CGRectMake(0, 0, 30, 30)
		self.layer.addSublayer(arrow)
		layers["刷新_icon_下拉刷新箭头"] = arrow
		
		resetLayerPropertiesForLayerIdentifiers(nil)
	}
	
	func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if layerIds == nil || layerIds.contains("刷新_icon_indicator"){
			let indicator = layers["刷新_icon_indicator"] as! CALayer
			indicator.contents = UIImage(named:"刷新_icon_indicator")?.CGImage
		}
		if layerIds == nil || layerIds.contains("刷新_icon_下拉刷新箭头"){
			let arrow = layers["刷新_icon_下拉刷新箭头"] as! CALayer
			arrow.contents = UIImage(named:"刷新_icon_下拉刷新箭头")?.CGImage
		}
		
		CATransaction.commit()
	}
	
	//MARK: - Animation Setup
	
	func addStartRefreshAnimation(){
		let fillMode : String = kCAFillModeForwards
		
		////An infinity animation
		
		////Indicator animation
		let indicatorTransformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		indicatorTransformAnim.values      = [360 * CGFloat(M_PI/180), 
			 0]
		indicatorTransformAnim.keyTimes    = [0, 1]
		indicatorTransformAnim.duration    = 1
		indicatorTransformAnim.repeatCount = Float.infinity
		
		let indicatorOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		indicatorOpacityAnim.values   = [0, 1]
		indicatorOpacityAnim.keyTimes = [0, 1]
		indicatorOpacityAnim.duration = 0.5
		
		let indicatorStartRefreshAnim : CAAnimationGroup = QCMethod.groupAnimations([indicatorTransformAnim, indicatorOpacityAnim], fillMode:fillMode)
		layers["刷新_icon_indicator"]?.addAnimation(indicatorStartRefreshAnim, forKey:"indicatorStartRefreshAnim")
		
		////Arrow animation
		let arrowTransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		arrowTransformAnim.values   = [-180 * CGFloat(M_PI/180), 
			 -360 * CGFloat(M_PI/180)]
		arrowTransformAnim.keyTimes = [0, 1]
		arrowTransformAnim.duration = 0.5
		
		let arrowOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		arrowOpacityAnim.values   = [1, 0]
		arrowOpacityAnim.keyTimes = [0, 1]
		arrowOpacityAnim.duration = 0.5
		
		let arrowStartRefreshAnim : CAAnimationGroup = QCMethod.groupAnimations([arrowTransformAnim, arrowOpacityAnim], fillMode:fillMode)
		layers["刷新_icon_下拉刷新箭头"]?.addAnimation(arrowStartRefreshAnim, forKey:"arrowStartRefreshAnim")
        
        self.hidden = false
	}
	
	func addFooterAnimation(){
		let fillMode : String = kCAFillModeForwards
		
		////An infinity animation
		
		////Indicator animation
		let indicatorTransformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		indicatorTransformAnim.values      = [0, 
			 -360 * CGFloat(M_PI/180)]
		indicatorTransformAnim.keyTimes    = [0, 1]
		indicatorTransformAnim.duration    = 1
		indicatorTransformAnim.repeatCount = Float.infinity
		
		let indicatorFooterAnimationAnim : CAAnimationGroup = QCMethod.groupAnimations([indicatorTransformAnim], fillMode:fillMode)
		layers["刷新_icon_indicator"]?.addAnimation(indicatorFooterAnimationAnim, forKey:"indicatorFooterAnimationAnim")
		
		////Arrow animation
		let arrowHiddenAnim         = CAKeyframeAnimation(keyPath:"hidden")
		arrowHiddenAnim.values      = [true, true]
		arrowHiddenAnim.keyTimes    = [0, 1]
		arrowHiddenAnim.duration    = 1
		arrowHiddenAnim.repeatCount = Float.infinity
		
		let arrowFooterAnimationAnim : CAAnimationGroup = QCMethod.groupAnimations([arrowHiddenAnim], fillMode:fillMode)
		layers["刷新_icon_下拉刷新箭头"]?.addAnimation(arrowFooterAnimationAnim, forKey:"arrowFooterAnimationAnim")
        
        self.hidden = false
	}
	
	//MARK: - Animation Cleanup
	
	override func animationDidStop(anim: CAAnimation, finished flag: Bool){
		if let completionBlock = completionBlocks[anim]{
			completionBlocks.removeValueForKey(anim)
			if (flag && updateLayerValueForCompletedAnimation) || anim.valueForKey("needEndAnim") as! Bool{
				updateLayerValuesForAnimationId(anim.valueForKey("animId") as! String)
				removeAnimationsForAnimationId(anim.valueForKey("animId") as! String)
			}
			completionBlock(flag)
		}
	}
	
	func updateLayerValuesForAnimationId(identifier: String){
		if identifier == "startRefresh"{
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["刷新_icon_indicator"] as! CALayer).animationForKey("indicatorStartRefreshAnim"), theLayer:(layers["刷新_icon_indicator"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["刷新_icon_下拉刷新箭头"] as! CALayer).animationForKey("arrowStartRefreshAnim"), theLayer:(layers["刷新_icon_下拉刷新箭头"] as! CALayer))
		}
		else if identifier == "footerAnimation"{
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["刷新_icon_indicator"] as! CALayer).animationForKey("indicatorFooterAnimationAnim"), theLayer:(layers["刷新_icon_indicator"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["刷新_icon_下拉刷新箭头"] as! CALayer).animationForKey("arrowFooterAnimationAnim"), theLayer:(layers["刷新_icon_下拉刷新箭头"] as! CALayer))
		}
	}
	
	func removeAnimationsForAnimationId(identifier: String){
		if identifier == "startRefresh"{
			(layers["刷新_icon_indicator"] as! CALayer).removeAnimationForKey("indicatorStartRefreshAnim")
			(layers["刷新_icon_下拉刷新箭头"] as! CALayer).removeAnimationForKey("arrowStartRefreshAnim")
		}
		else if identifier == "footerAnimation"{
			(layers["刷新_icon_indicator"] as! CALayer).removeAnimationForKey("indicatorFooterAnimationAnim")
			(layers["刷新_icon_下拉刷新箭头"] as! CALayer).removeAnimationForKey("arrowFooterAnimationAnim")
		}
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
			(layer as! CALayer).removeAllAnimations()
		}
        self.hidden = true
    }
}
