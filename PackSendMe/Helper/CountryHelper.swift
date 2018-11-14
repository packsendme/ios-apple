//
//  CountryHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 14/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class CountryHelper {

    var countries: [CountryModel] = []
    var countriesData: [CountryModel] = []
    
    func createCountries() -> [CountryModel]{
        
        if countries.isEmpty{
            let afghanistan = CountryModel(countryImage:#imageLiteral(resourceName: "iconAfghanistan"), name:NSLocalizedString("country-afghanistan", comment:""),cod:NSLocalizedString("afghanistan-cod", comment:""), format:NSLocalizedString("afghanistan-format", comment:""))

            let albania = CountryModel(countryImage:#imageLiteral(resourceName: "iconAlbania"), name:NSLocalizedString("country-albania", comment:""),cod:NSLocalizedString("albania-cod", comment:""), format:NSLocalizedString("albania-format", comment:""))
            
            let algeria = CountryModel(countryImage:#imageLiteral(resourceName: "iconAlgeria"), name:NSLocalizedString("country-algeria", comment:""),cod:NSLocalizedString("algeria-cod", comment:""), format:NSLocalizedString("algeria-format", comment:""))
            
            let andorra = CountryModel(countryImage:#imageLiteral(resourceName: "iconAndorra"), name:NSLocalizedString("country-andorra", comment:""),cod:NSLocalizedString("andorra-cod", comment:""), format:NSLocalizedString("andorra-format", comment:""))
            
            let angola = CountryModel(countryImage:#imageLiteral(resourceName: "iconAngola"), name:NSLocalizedString("country-angola", comment:""),cod:NSLocalizedString("angola-cod", comment:""), format:NSLocalizedString("angola-format", comment:""))
            
            let anguilla = CountryModel(countryImage:#imageLiteral(resourceName: "iconAnguilla"), name:NSLocalizedString("country-anguilla", comment:""),cod:NSLocalizedString("anguilla-cod", comment:""), format:NSLocalizedString("anguilla-format", comment:""))
            
            let argentina = CountryModel(countryImage:#imageLiteral(resourceName: "iconArgentina"), name:NSLocalizedString("country-argentina", comment:""),cod:NSLocalizedString("argentina-cod", comment:""), format:NSLocalizedString("argentina-format", comment:""))
            
            let armenia = CountryModel(countryImage:#imageLiteral(resourceName: "iconArmenia"), name:NSLocalizedString("country-armenia", comment:""),cod:NSLocalizedString("armenia-cod", comment:""), format:NSLocalizedString("armenia-format", comment:""))
            
            let australia = CountryModel(countryImage:#imageLiteral(resourceName: "iconAustralia"), name:NSLocalizedString("country-australia", comment:""),cod:NSLocalizedString("australia-cod", comment:""), format:NSLocalizedString("australia-format", comment:""))
            
            let austria = CountryModel(countryImage:#imageLiteral(resourceName: "iconAustria"), name:NSLocalizedString("country-austria", comment:""),cod:NSLocalizedString("austria-cod", comment:""), format:NSLocalizedString("austria-format", comment:""))
            
            let bahamas = CountryModel(countryImage:#imageLiteral(resourceName: "iconBahamas"), name:NSLocalizedString("country-bahamas", comment:""),cod:NSLocalizedString("bahamas-cod", comment:""), format:NSLocalizedString("bahamas-format", comment:""))
            
            let brazil = CountryModel(countryImage:#imageLiteral(resourceName: "imgBrazil"), name:NSLocalizedString("country-brazil", comment:""),cod:NSLocalizedString("brazil-cod", comment:""), format:NSLocalizedString("brazil-format", comment:""))
            
            let belgium = CountryModel(countryImage:#imageLiteral(resourceName: "iconBelgium"), name:NSLocalizedString("country-belgium", comment:""),cod:NSLocalizedString("belgium-cod", comment:""), format:NSLocalizedString("belgium-format", comment:""))

            let bolivia = CountryModel(countryImage:#imageLiteral(resourceName: "iconBolivia"), name:NSLocalizedString("country-bolivia", comment:""),cod:NSLocalizedString("bolivia-cod", comment:""), format:NSLocalizedString("bolivia-format", comment:""))
            
            let bulgaria = CountryModel(countryImage:#imageLiteral(resourceName: "iconBulgaria"), name:NSLocalizedString("country-bulgaria", comment:""),cod:NSLocalizedString("bulgaria-cod", comment:""), format:NSLocalizedString("bulgaria-format", comment:""))
            
            let cambodia = CountryModel(countryImage:#imageLiteral(resourceName: "iconCambodia"), name:NSLocalizedString("country-cambodia", comment:""),cod:NSLocalizedString("cambodia-cod", comment:""), format:NSLocalizedString("cambodia-format", comment:""))
            
            let canada = CountryModel(countryImage:#imageLiteral(resourceName: "iconCanada"), name:NSLocalizedString("country-canada", comment:""),cod:NSLocalizedString("canada-cod", comment:""), format:NSLocalizedString("canada-format", comment:""))
      
            let centralafrican = CountryModel(countryImage:#imageLiteral(resourceName: "iconAfricana"), name:NSLocalizedString("country-centralafrican", comment:""),cod:NSLocalizedString("centralafrican-cod", comment:""), format:NSLocalizedString("centralafrican-format", comment:""))

            let chile = CountryModel(countryImage:#imageLiteral(resourceName: "iconChile"), name:NSLocalizedString("country-chile", comment:""),cod:NSLocalizedString("chile-cod", comment:""), format:NSLocalizedString("chile-format", comment:""))
            
            let china = CountryModel(countryImage:#imageLiteral(resourceName: "iconChina"), name:NSLocalizedString("country-china", comment:""),cod:NSLocalizedString("china-cod", comment:""), format:NSLocalizedString("china-format", comment:""))
            
            let colombia = CountryModel(countryImage:#imageLiteral(resourceName: "iconColombia"), name:NSLocalizedString("country-colombia", comment:""),cod:NSLocalizedString("colombia-cod", comment:""), format:NSLocalizedString("colombia-format", comment:""))
 
            let costarica = CountryModel(countryImage:#imageLiteral(resourceName: "iconCostarica"), name:NSLocalizedString("country-costarica", comment:""),cod:NSLocalizedString("costarica-cod", comment:""), format:NSLocalizedString("costarica-format", comment:""))

            let czechia = CountryModel(countryImage:#imageLiteral(resourceName: "iconCzechrepublic"), name:NSLocalizedString("country-czechia", comment:""),cod:NSLocalizedString("czechia-cod", comment:""), format:NSLocalizedString("czechia-format", comment:""))
            
            let denmark = CountryModel(countryImage:#imageLiteral(resourceName: "iconsDenmark"), name:NSLocalizedString("country-denmark", comment:""),cod:NSLocalizedString("denmark-cod", comment:""), format:NSLocalizedString("denmark-format", comment:""))
            
            let dominicanRepublic = CountryModel(countryImage:#imageLiteral(resourceName: "iconDominicanrepublic"), name:NSLocalizedString("country-dominicanRepublic", comment:""),cod:NSLocalizedString("dominicanRepublic-cod", comment:""), format:NSLocalizedString("dominicanRepublic-format", comment:""))

            let ecuador = CountryModel(countryImage:#imageLiteral(resourceName: "iconsEcuador"), name:NSLocalizedString("country-ecuador", comment:""),cod:NSLocalizedString("ecuador-cod", comment:""), format:NSLocalizedString("ecuador-format", comment:""))

            let egypt = CountryModel(countryImage:#imageLiteral(resourceName: "iconsEgypt"), name:NSLocalizedString("country-egypt", comment:""),cod:NSLocalizedString("egypt-cod", comment:""), format:NSLocalizedString("egypt-format", comment:""))
            
            let estonia = CountryModel(countryImage:#imageLiteral(resourceName: "iconsEstonia"), name:NSLocalizedString("country-estonia", comment:""),cod:NSLocalizedString("estonia-cod", comment:""), format:NSLocalizedString("estonia-format", comment:""))
  
            let finland = CountryModel(countryImage:#imageLiteral(resourceName: "iconFinland"), name:NSLocalizedString("country-finland", comment:""),cod:NSLocalizedString("finland-cod", comment:""), format:NSLocalizedString("finland-format", comment:""))
            
            let france = CountryModel(countryImage:#imageLiteral(resourceName: "iconFrance"), name:NSLocalizedString("country-france", comment:""),cod:NSLocalizedString("france-cod", comment:""), format:NSLocalizedString("france-format", comment:""))

            let frenchpolynesia = CountryModel(countryImage:#imageLiteral(resourceName: "iconFrenchpolynesia"), name:NSLocalizedString("country-frenchpolynesia", comment:""),cod:NSLocalizedString("frenchpolynesia-cod", comment:""), format:NSLocalizedString("frenchpolynesia-format", comment:""))
           
            let georgia = CountryModel(countryImage:#imageLiteral(resourceName: "iconGeorgia"), name:NSLocalizedString("country-georgia", comment:""),cod:NSLocalizedString("georgia-cod", comment:""), format:NSLocalizedString("georgia-format", comment:""))
            
            let germany = CountryModel(countryImage:#imageLiteral(resourceName: "iconGermany"), name:NSLocalizedString("country-germany", comment:""),cod:NSLocalizedString("germany-cod", comment:""), format:NSLocalizedString("germany-format", comment:""))
            
            let ghana = CountryModel(countryImage:#imageLiteral(resourceName: "iconGhana"), name:NSLocalizedString("country-ghana", comment:""),cod:NSLocalizedString("ghana-cod", comment:""), format:NSLocalizedString("ghana-format", comment:""))
            
            let greece = CountryModel(countryImage:#imageLiteral(resourceName: "iconGreece"), name:NSLocalizedString("country-greece", comment:""),cod:NSLocalizedString("greece-cod", comment:""), format:NSLocalizedString("greece-format", comment:""))
            
            let guatemala = CountryModel(countryImage:#imageLiteral(resourceName: "iconGuatemala"), name:NSLocalizedString("country-guatemala", comment:""),cod:NSLocalizedString("guatemala-cod", comment:""), format:NSLocalizedString("guatemala-format", comment:""))
            
            let guinea = CountryModel(countryImage:#imageLiteral(resourceName: "iconGuinea"), name:NSLocalizedString("country-guinea", comment:""),cod:NSLocalizedString("guinea-cod", comment:""), format:NSLocalizedString("guinea-format", comment:""))
            
            let haiti = CountryModel(countryImage:#imageLiteral(resourceName: "iconHaiti"), name:NSLocalizedString("country-haiti", comment:""),cod:NSLocalizedString("haiti-cod", comment:""), format:NSLocalizedString("haiti-format", comment:""))
            
            let honduras = CountryModel(countryImage:#imageLiteral(resourceName: "iconHonduras"), name:NSLocalizedString("country-honduras", comment:""),cod:NSLocalizedString("honduras-cod", comment:""), format:NSLocalizedString("honduras-format", comment:""))
            
            let hungary = CountryModel(countryImage:#imageLiteral(resourceName: "iconHungary"), name:NSLocalizedString("country-hungary", comment:""),cod:NSLocalizedString("hungary-cod", comment:""), format:NSLocalizedString("hungary-format", comment:""))
            

            let iceland = CountryModel(countryImage:#imageLiteral(resourceName: "iconIceland"), name:NSLocalizedString("country-iceland", comment:""),cod:NSLocalizedString("iceland-cod", comment:""), format:NSLocalizedString("iceland-format", comment:""))
            
            let india = CountryModel(countryImage:#imageLiteral(resourceName: "iconIndia"), name:NSLocalizedString("country-india", comment:""),cod:NSLocalizedString("india-cod", comment:""), format:NSLocalizedString("india-format", comment:""))
            
            let indonesia = CountryModel(countryImage:#imageLiteral(resourceName: "iconIndonesia"), name:NSLocalizedString("country-indonesia", comment:""),cod:NSLocalizedString("indonesia-cod", comment:""), format:NSLocalizedString("indonesia-format", comment:""))
            
            let iran = CountryModel(countryImage:#imageLiteral(resourceName: "iconIran"), name:NSLocalizedString("country-iran", comment:""),cod:NSLocalizedString("iran-cod", comment:""), format:NSLocalizedString("iran-format", comment:""))
            
            let ireland = CountryModel(countryImage:#imageLiteral(resourceName: "iconIreland"), name:NSLocalizedString("country-ireland", comment:""),cod:NSLocalizedString("ireland-cod", comment:""), format:NSLocalizedString("ireland-format", comment:""))
            
            let israel = CountryModel(countryImage:#imageLiteral(resourceName: "iconIsrael"), name:NSLocalizedString("country-israel", comment:""),cod:NSLocalizedString("israel-cod", comment:""), format:NSLocalizedString("israel-format", comment:""))
            
            let italy = CountryModel(countryImage:#imageLiteral(resourceName: "iconItalia"), name:NSLocalizedString("country-italy", comment:""),cod:NSLocalizedString("italy-cod", comment:""), format:NSLocalizedString("italy-format", comment:""))
            
            let jamaica = CountryModel(countryImage:#imageLiteral(resourceName: "iconJamaica"), name:NSLocalizedString("country-jamaica", comment:""),cod:NSLocalizedString("jamaica-cod", comment:""), format:NSLocalizedString("jamaica-format", comment:""))
            
            let japao = CountryModel(countryImage:#imageLiteral(resourceName: "iconJapan"), name:NSLocalizedString("country-japao", comment:""),cod:NSLocalizedString("japao-cod", comment:""), format:NSLocalizedString("japao-format", comment:""))
            
            let jordan = CountryModel(countryImage:#imageLiteral(resourceName: "iconJordan"), name:NSLocalizedString("country-jordan", comment:""),cod:NSLocalizedString("jordan-cod", comment:""), format:NSLocalizedString("jordan-format", comment:""))
      
            let kenya = CountryModel(countryImage:#imageLiteral(resourceName: "iconKenya"), name:NSLocalizedString("country-kenya", comment:""),cod:NSLocalizedString("kenya-cod", comment:""), format:NSLocalizedString("kenya-format", comment:""))
      
            let luxembourg = CountryModel(countryImage:#imageLiteral(resourceName: "iconLuxembourg"), name:NSLocalizedString("country-luxembourg", comment:""),cod:NSLocalizedString("luxembourg-cod", comment:""), format:NSLocalizedString("luxembourg-format", comment:""))

            let lihuania = CountryModel(countryImage:#imageLiteral(resourceName: "iconLithuania"), name:NSLocalizedString("country-lihuania", comment:""),cod:NSLocalizedString("lihuania-cod", comment:""), format:NSLocalizedString("lihuania-format", comment:""))

            let macedonia = CountryModel(countryImage:#imageLiteral(resourceName: "iconMacedonia"), name:NSLocalizedString("country-macedonia", comment:""),cod:NSLocalizedString("macedonia-cod", comment:""), format:NSLocalizedString("macedonia-format", comment:""))

            let madagascar = CountryModel(countryImage:#imageLiteral(resourceName: "iconMadagascar"), name:NSLocalizedString("country-madagascar", comment:""),cod:NSLocalizedString("madagascar-cod", comment:""), format:NSLocalizedString("madagascar-format", comment:""))

            let mexico = CountryModel(countryImage:#imageLiteral(resourceName: "iconMexico"), name:NSLocalizedString("country-mexico", comment:""),cod:NSLocalizedString("mexico-cod", comment:""), format:NSLocalizedString("mexico-format", comment:""))

            let monaco = CountryModel(countryImage:#imageLiteral(resourceName: "iconIndonesia"), name:NSLocalizedString("country-monaco", comment:""),cod:NSLocalizedString("monaco-cod", comment:""), format:NSLocalizedString("monaco-format", comment:""))

            let marocco = CountryModel(countryImage:#imageLiteral(resourceName: "iconMorocco"), name:NSLocalizedString("country-marocco", comment:""),cod:NSLocalizedString("marocco-cod", comment:""), format:NSLocalizedString("marocco-format", comment:""))

            let mozambique = CountryModel(countryImage:#imageLiteral(resourceName: "iconMozambique"), name:NSLocalizedString("country-mozambique", comment:""),cod:NSLocalizedString("mozambique-cod", comment:""), format:NSLocalizedString("mozambique-format", comment:""))

            let norway = CountryModel(countryImage:#imageLiteral(resourceName: "iconNorway"), name:NSLocalizedString("country-norway", comment:""),cod:NSLocalizedString("norway-cod", comment:""), format:NSLocalizedString("norway-format", comment:""))

            let northkorea = CountryModel(countryImage:#imageLiteral(resourceName: "iconNorthkorea"), name:NSLocalizedString("country-northkorea", comment:""),cod:NSLocalizedString("northkorea-cod", comment:""), format:NSLocalizedString("northkorea-format", comment:""))

            let netherlands = CountryModel(countryImage:#imageLiteral(resourceName: "iconNetherlands"), name:NSLocalizedString("country-netherlands", comment:""),cod:NSLocalizedString("netherlands-cod", comment:""), format:NSLocalizedString("netherlands-format", comment:""))

            let nepal = CountryModel(countryImage:#imageLiteral(resourceName: "iconNepal"), name:NSLocalizedString("country-nepal", comment:""),cod:NSLocalizedString("nepal-cod", comment:""), format:NSLocalizedString("nepal-format", comment:""))

            let newzealand = CountryModel(countryImage:#imageLiteral(resourceName: "iconNewzealand"), name:NSLocalizedString("country-newzealand", comment:""),cod:NSLocalizedString("newzealand-cod", comment:""), format:NSLocalizedString("newzealand-format", comment:""))

            let nigeria = CountryModel(countryImage:#imageLiteral(resourceName: "iconNigeria"), name:NSLocalizedString("country-nigeria", comment:""),cod:NSLocalizedString("nigeria-cod", comment:""), format:NSLocalizedString("nigeria-format", comment:""))

            let panama = CountryModel(countryImage:#imageLiteral(resourceName: "iconPanama"), name:NSLocalizedString("country-panama", comment:""),cod:NSLocalizedString("panama-cod", comment:""), format:NSLocalizedString("panama-format", comment:""))

            let paraguay = CountryModel(countryImage:#imageLiteral(resourceName: "iconParaguay"), name:NSLocalizedString("country-paraguay", comment:""),cod:NSLocalizedString("paraguay-cod", comment:""), format:NSLocalizedString("paraguay-format", comment:""))

            let peru = CountryModel(countryImage:#imageLiteral(resourceName: "iconPeru"), name:NSLocalizedString("country-peru", comment:""),cod:NSLocalizedString("peru-cod", comment:""), format:NSLocalizedString("peru-format", comment:""))

            let philippines = CountryModel(countryImage:#imageLiteral(resourceName: "iconPhilippines"), name:NSLocalizedString("country-philippines", comment:""),cod:NSLocalizedString("philippines-cod", comment:""), format:NSLocalizedString("philippines-format", comment:""))

            let poland = CountryModel(countryImage:#imageLiteral(resourceName: "iconPoland"), name:NSLocalizedString("country-poland", comment:""),cod:NSLocalizedString("poland-cod", comment:""), format:NSLocalizedString("poland-format", comment:""))

            let portugal = CountryModel(countryImage:#imageLiteral(resourceName: "iconPortugal"), name:NSLocalizedString("country-portugal", comment:""),cod:NSLocalizedString("portugal-cod", comment:""), format:NSLocalizedString("portugal-format", comment:""))

            let puertorico = CountryModel(countryImage:#imageLiteral(resourceName: "iconPuertorico"), name:NSLocalizedString("country-puertorico", comment:""),cod:NSLocalizedString("puertorico-cod", comment:""), format:NSLocalizedString("puertorico-format", comment:""))

            let qatar = CountryModel(countryImage:#imageLiteral(resourceName: "iconQatar"), name:NSLocalizedString("country-qatar", comment:""),cod:NSLocalizedString("qatar-cod", comment:""), format:NSLocalizedString("qatar-format", comment:""))

            let romania = CountryModel(countryImage:#imageLiteral(resourceName: "iconRomania"), name:NSLocalizedString("country-romania", comment:""),cod:NSLocalizedString("romania-cod", comment:""), format:NSLocalizedString("romania-format", comment:""))

            let russia = CountryModel(countryImage:#imageLiteral(resourceName: "iconRussian"), name:NSLocalizedString("country-russia", comment:""),cod:NSLocalizedString("russia-cod", comment:""), format:NSLocalizedString("russia-format", comment:""))

            let saudiarabia = CountryModel(countryImage:#imageLiteral(resourceName: "iconSaudiarabia"), name:NSLocalizedString("country-saudiarabia", comment:""),cod:NSLocalizedString("saudiarabia-cod", comment:""), format:NSLocalizedString("saudiarabia-format", comment:""))

            let senegal = CountryModel(countryImage:#imageLiteral(resourceName: "iconSenegal"), name:NSLocalizedString("country-senegal", comment:""),cod:NSLocalizedString("senegal-cod", comment:""), format:NSLocalizedString("senegal-format", comment:""))

            let singapore = CountryModel(countryImage:#imageLiteral(resourceName: "iconSingapore"), name:NSLocalizedString("country-singapore", comment:""),cod:NSLocalizedString("singapore-cod", comment:""), format:NSLocalizedString("singapore-format", comment:""))

            let southafrica = CountryModel(countryImage:#imageLiteral(resourceName: "iconSouthafrica"), name:NSLocalizedString("country-southafrica", comment:""),cod:NSLocalizedString("southafrica-cod", comment:""), format:NSLocalizedString("southafrica-format", comment:""))

            let southkorea = CountryModel(countryImage:#imageLiteral(resourceName: "iconSouthkorea"), name:NSLocalizedString("country-southkorea", comment:""),cod:NSLocalizedString("southkorea-cod", comment:""), format:NSLocalizedString("southkorea-format", comment:""))

            let spain = CountryModel(countryImage:#imageLiteral(resourceName: "imgSpain"), name:NSLocalizedString("country-spain", comment:""),cod:NSLocalizedString("spain-cod", comment:""), format:NSLocalizedString("spain-format", comment:""))

            let swaziland = CountryModel(countryImage:#imageLiteral(resourceName: "iconSwaziland"), name:NSLocalizedString("country-swaziland", comment:""),cod:NSLocalizedString("swaziland-cod", comment:""), format:NSLocalizedString("swaziland-format", comment:""))
            
            let sweden = CountryModel(countryImage:#imageLiteral(resourceName: "iconSweden"), name:NSLocalizedString("country-sweden", comment:""),cod:NSLocalizedString("sweden-cod", comment:""), format:NSLocalizedString("sweden-format", comment:""))

            let switzerland = CountryModel(countryImage:#imageLiteral(resourceName: "iconSwitzerland"), name:NSLocalizedString("country-switzerland", comment:""),cod:NSLocalizedString("switzerland-cod", comment:""), format:NSLocalizedString("switzerland-format", comment:""))

            let syria = CountryModel(countryImage:#imageLiteral(resourceName: "iconSyria"), name:NSLocalizedString("country-syria", comment:""),cod:NSLocalizedString("syria-cod", comment:""), format:NSLocalizedString("syria-format", comment:""))

            let eua = CountryModel(countryImage:#imageLiteral(resourceName: "iconUSA"), name:NSLocalizedString("country-eua", comment:""),cod:NSLocalizedString("eua-cod", comment:""), format:NSLocalizedString("eua-format", comment:""))

            let taiwan = CountryModel(countryImage:#imageLiteral(resourceName: "iconTaiwan"), name:NSLocalizedString("country-taiwan", comment:""),cod:NSLocalizedString("taiwan-cod", comment:""), format:NSLocalizedString("taiwan-format", comment:""))

            let thailand = CountryModel(countryImage:#imageLiteral(resourceName: "iconTailandia"), name:NSLocalizedString("country-thailand", comment:""),cod:NSLocalizedString("thailand-cod", comment:""), format:NSLocalizedString("thailand-format", comment:""))

            let tunisia = CountryModel(countryImage:#imageLiteral(resourceName: "iconTunisia"), name:NSLocalizedString("country-tunisia", comment:""),cod:NSLocalizedString("tunisia-cod", comment:""), format:NSLocalizedString("tunisia-format", comment:""))
            
            let uruguay = CountryModel(countryImage:#imageLiteral(resourceName: "iconUruguai"), name:NSLocalizedString("country-uruguay", comment:""),cod:NSLocalizedString("uruguay-cod", comment:""), format:NSLocalizedString("uruguay-format", comment:""))

            let ukraine = CountryModel(countryImage:#imageLiteral(resourceName: "iconUcrania"), name:NSLocalizedString("country-ukraine", comment:""),cod:NSLocalizedString("ukraine-cod", comment:""), format:NSLocalizedString("ukraine-format", comment:""))
            
            let unitedkingdom = CountryModel(countryImage:#imageLiteral(resourceName: "iconGrabretanha"), name:NSLocalizedString("country-unitedkingdom", comment:""),cod:NSLocalizedString("unitedkingdom-cod", comment:""), format:NSLocalizedString("unitedkingdom-format", comment:""))
 
            let unitedarabemirates = CountryModel(countryImage:#imageLiteral(resourceName: "iconSaudiarabia"), name:NSLocalizedString("country-unitedarabemirates", comment:""),cod:NSLocalizedString("unitedarabemirates-cod", comment:""), format:NSLocalizedString("unitedarabemirates-format", comment:""))

            let vaticancity = CountryModel(countryImage:#imageLiteral(resourceName: "iconVatican"), name:NSLocalizedString("country-vaticancity", comment:""),cod:NSLocalizedString("vaticancity-cod", comment:""), format:NSLocalizedString("vaticancity-format", comment:""))

            let venezuela = CountryModel(countryImage:#imageLiteral(resourceName: "iconVenezuela"), name:NSLocalizedString("country-venezuela", comment:""),cod:NSLocalizedString("venezuela-cod", comment:""), format:NSLocalizedString("venezuela-format", comment:""))

            let vietnam = CountryModel(countryImage:#imageLiteral(resourceName: "iconVietname"), name:NSLocalizedString("country-vietnam", comment:""),cod:NSLocalizedString("vietnam-cod", comment:""), format:NSLocalizedString("vietnam-format", comment:""))
            
            self.countries =  [afghanistan,albania,algeria,andorra,angola,anguilla,argentina,armenia,australia,austria,
                 bahamas,brazil,belgium,bolivia,bulgaria,cambodia,canada,centralafrican,chile,
            china,colombia,costarica,czechia,denmark,dominicanRepublic,ecuador,egypt,estonia,finland,
            france,frenchpolynesia,georgia,germany,ghana,greece,guatemala,guinea,haiti,honduras,hungary,
            iceland,india,indonesia,iran,ireland,israel,italy,jamaica,japao,jordan,kenya,luxembourg,lihuania,
            macedonia,madagascar,mexico,monaco,marocco,mozambique,norway,northkorea,netherlands,nepal,
            newzealand,nigeria,panama,paraguay,peru,philippines,poland,portugal,puertorico,qatar,romania,
            russia,saudiarabia,senegal,singapore,southafrica,southkorea,spain,swaziland,sweden,switzerland,syria,
                eua,taiwan,thailand,tunisia,uruguay,ukraine,unitedkingdom,unitedarabemirates,vaticancity,
                venezuela,vietnam]
            
            countriesData = self.countries
            countriesData.sort(by: {$0.name < $1.name})
        }

        return countriesData
    }
    
    func getCountryCallingCode() -> String{
        
        let currentLocale: NSLocale = NSLocale.current as NSLocale
        let countryRegionCode = currentLocale.object(forKey: NSLocale.Key.countryCode) as! String
        print("country code is \(countryRegionCode)")

        let prefixCodes = ["AF": "+93", "AE": "+971", "AL": "+355", "AN": "+599", "AS":"+1", "AD": "+376", "AO": "+244", "AI": "+1", "AG":"+1", "AR": "+54","AM": "+374", "AW": "+297", "AU":"+61", "AT": "+43","AZ": "+994", "BS": "+1", "BH":"+973", "BF": "+226","BI": "+257", "BD": "+880", "BB": "+1", "BY": "+375", "BE":"+32","BZ": "+501", "BJ": "+229", "BM": "+1", "BT":"+975", "BA": "+387", "BW": "+267", "BR": "+55", "BG": "+359", "BO": "+591", "BL": "+590", "BN": "+673", "CC": "+61", "CD":"+243","CI": "+225", "KH":"+855", "CM": "237", "CA": "+1", "CV": "+238", "KY":"+345", "CF":"+236", "CH": "+41", "CL": "+56", "CN":"+86","CX": "+61", "CO": "+57", "KM": "+269", "CG":"+242", "CK": "+682", "CR": "+506", "CU":"+53", "CY":"+537","CZ": "+420", "DE": "+49", "DK": "+45", "DJ":"+253", "DM": "+1", "DO": "+1", "DZ": "+213", "EC": "+593", "EG":"+20", "ER": "+291", "EE":"+372","ES": "+34", "ET": "+251", "FM": "+691", "FK": "+500", "FO": "+298", "FJ": "+679", "FI":"+358", "FR": "+33", "GB":"+44", "GF": "+594", "GA":"+241", "GS": "+500", "GM":"+220", "GE":"+995","GH":"+233", "GI": "+350", "GQ": "+240", "GR": "+30", "GG": "+44", "GL": "+299", "GD":"+1", "GP": "+590", "GU": "+1", "GT": "+502", "GN":"+224","GW": "+245", "GY": "+595", "HT": "+509", "HR": "+385", "HN":"+504", "HU": "+36", "HK": "+852", "IR": "+98", "IM": "+44", "IL": "+972", "IO":"+246", "IS": "+354", "IN": "+91", "ID":"+62", "IQ":"+964", "IE": "+353","IT":"39", "JM":"+1", "JP": "+81", "JO": "+962", "JE":"+44", "KP": "+850", "KR": "+82","KZ":"+77", "KE": "+254", "KI": "+686", "KW": "+965", "KG":"+996","KN":"+1", "LC": "+1", "LV": "+371", "LB": "+961", "LK":"+94", "LS": "+266", "LR":"+231", "LI": "+423", "LT": "+370", "LU": "+352", "LA": "+856", "LY":"+218", "MO": "+853", "MK": "+389", "MG":"+261", "MW": "+265", "MY": "+60","MV": "+960", "ML":"+223", "MT": "+356", "MH": "+692", "MQ": "+596", "MR":"+222", "MU": "+230", "MX": "+52","MC": "+377", "MN": "+976", "ME": "+382", "MP": "+1", "MS": "+1", "MA":"+212", "MM": "+95", "MF": "+590", "MD":"+373", "MZ": "+258", "NA":"+264", "NR":"+674", "NP":"+977", "NL": "+31","NC": "+687", "NZ":"+64", "NI": "+505", "NE": "+227", "NG": "+234", "NU":"+683", "NF": "+672", "NO": "+47","OM": "+968", "PK": "+92", "PM": "+508", "PW": "+680", "PF": "+689", "PA": "+507", "PG":"675", "PY": "+595", "PE": "+51", "PH": "+63", "PL":"+48", "PN": "+872","PT": "+351", "PR": "+1","PS": "+970", "QA": "+974", "RO":"+40", "RE":"+262", "RS": "+381", "RU": "+7", "RW": "+250", "SM": "+378", "SA":"+966", "SN": "+221", "SC": "+248", "SL":"+232","SG": "+65", "SK": "+421", "SI": "+386", "SB":"+677", "SH": "+290", "SD": "+249", "SR": "+597","SZ": "+268", "SE":"+46", "SV": "+503", "ST": "+239","SO": "+252", "SJ": "+47", "SY":"+963", "TW": "+886", "TZ": "+255", "TL": "+670", "TD": "+235", "TJ": "+992", "TH": "+66", "TG":"+228", "TK": "+690", "TO": "+676", "TT": "+1", "TN":"+216","TR": "+90", "TM": "+993", "TC": "+1", "TV":"+688", "UG": "+256", "UA": "+380", "US": "+1", "UY": "+598","UZ": "+998", "VA":"+379", "VE":"+58", "VN": "+84", "VG": "+1", "VI": "+1","VC":"+1", "VU":"+678", "WS": "+685", "WF": "+681", "YE": "+967", "YT": "+262","ZA": "+27" , "ZM": "+260", "ZW":"+263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode!
        
    }
    
    func findCountryCurrent(codeCountry: String, countriesFull: [CountryModel]) -> CountryModel{

        let countryNotFound = CountryModel(countryImage:#imageLiteral(resourceName: "iconUSA"), name:NSLocalizedString("country-eua", comment:""),cod:NSLocalizedString("eua-cod", comment:""), format:NSLocalizedString("eua-format", comment:""))
        
        if let item = countriesFull.first(where: { $0.cod == codeCountry }) {
           return item
        } else {
            return countryNotFound
        }
    }
    
}
