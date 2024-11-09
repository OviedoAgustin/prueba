import plantas.*

class Parcela {
    const property ancho

    const property largo 

    const property horasDeSol

    const property plantas = []

    method superficie() = ancho * largo
/*
    method cantidadMaximaPlantas () {
        if (ancho > largo) {return self.superficie() / 5}
        else {return self.superficie() / 3 + largo}
    }
*/
    method cantidadMaximaPlantas(){
        if (ancho>largo) return self.superficie() / 5
        else return self.superficie()/3 + largo  
    }

    method cantidadPlantas() = plantas.size()

    method plantaEstaBienAsociada(unaPlanta)

    method tieneComplicaciones() = plantas.any({ p => p.horasAlSol() < horasDeSol })
/*
    method plantarPlanta(unaPlanta) {
        if (self.cantidadPlantas()>=self.cantidadMaximaPlantas() || self.horasDeSol()-unaPlanta.horasAlSol() >= 2){
            self.error("No se puede agregar mas plantas")
        } 
        else{
            plantas.add(unaPlanta)
        }
    }
*/

    method plantarPlanta(unaPlanta) {
        if (self.cantidadPlantas()>=self.cantidadMaximaPlantas()){
            if (horasDeSol-unaPlanta.horasAlSol() >= 2){
                self.error("No se puede plantar esta planta")
            }
            else {
                self.error("No se admiten mas plantas")
            }
        }
        else 
            plantas.add(unaPlanta)
    } 

    method tienePlantaMayorA (metros) = plantas.any({ p => p.altura() > metros })

    method cantidadPlantasBienAsociadas() = plantas.count({ p => self.plantaEstaBienAsociada(p) })

    method porcentajePlantasBienAsociadas() = (self.cantidadPlantasBienAsociadas() / self.cantidadPlantas()) * 100
}

class ParcelaEcologica inherits Parcela {
    override method plantaEstaBienAsociada(unaPlanta) = not self.tieneComplicaciones() && unaPlanta.parcelaIdeal(self)
}

class ParcelaIndustrial inherits Parcela {
    override method plantaEstaBienAsociada(unaPlanta) = self.cantidadMaximaPlantas() == 2 && unaPlanta.esFuerte()
}
/*
object inta {
    const property parcelas = []

    method promedioPlantasPorParcela() = self.totalDePlantas() / self.cantidadParcelas()

    method totalDePlantas() = parcelas.sum({ p => p.cantidadPlantas() })

    method cantidadParcelas() = parcelas.size()

    method parcelaMasAutosustentable() = self.parcelasConMasDe(4).max({ p => p.porcentajePlantasBienAsociadas() })

    method parcelasConMasDe(numPlantas) = parcelas.filter({ p => p.cantidadPlantas() > numPlantas })

    
}
*/
object inta {
    const property parcelas = []

    method agregarParcelas(listaParcelas){
        parcelas.addAll(listaParcelas)
    }

    method promedioPlantasPorParcela() = self.totalDePlantas() / self.cantidadParcelas()

    method totalDePlantas() = parcelas.sum({ p => p.cantidadPlantas() })

    method cantidadParcelas() = parcelas.size()

   method parcelaMasAutosustentable() = self.parcelasConMasDe(4).max({p=>p.porcentajePlantasBienAsociadas()})

   method parcelasConMasDe(unaCantidad) = parcelas.filter({p=>p.cantidadPlantas()>unaCantidad})
}

------------------------------------------------------------------------------------------------------- Parcelas

class Planta {
  const property anioObtencion
  const property altura

  method esFuerte() = self.horasAlSol() > 10

  method daSemillas() = self.esFuerte()

  method horasAlSol()

  method parcelaIdeal(unaParcela)
}

class Menta inherits Planta {
  override method horasAlSol() = 6

  override method daSemillas() = super() || altura > 0.4

  method espacioQueOcupa() = altura * 3

  override method parcelaIdeal(unaParcela) = unaParcela.superficie() > 6
}

class HierbaBuena inherits Menta {
  override method espacioQueOcupa() = super() * 2
}

class Soja inherits Planta {
  override method horasAlSol() {
    if (altura < 0.5) {return 6}
    else if (altura.between(0.5, 1)) {return 7}
    else {return 9}
  }

  override method daSemillas() = super() || self.esAltaYReciente()

  method esAltaYReciente() = anioObtencion > 2007 && altura > 1

  method espacioQueOcupa() = altura / 2

  override method parcelaIdeal(unaParcela) = self.horasAlSol() == unaParcela.horasDeSol()
}

class SojaTransgenica inherits Soja {
  override method daSemillas() = false

  override method parcelaIdeal(unaParcela) = unaParcela.cantidadMaximaPlantas() == 1
}

class Quinoa inherits Planta {
  const property horasAlSol

  method espacioQueOcupa() = 0.5

  override method daSemillas() = super() || anioObtencion < 2005

  override method parcelaIdeal(unaParcela) = not unaParcela.tienePlantaMayorA(1.5)
}

---------------------------------------------------------------------------------------------- plantas

