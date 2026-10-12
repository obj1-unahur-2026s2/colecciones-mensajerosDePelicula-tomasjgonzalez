object roberto {
  var pesoPropio = 90
  var medioDeTransporte = bicicleta

  method cambiarPeso(unPeso) { pesoPropio = unPeso }
  method cambiarTransporte(unTransporte) { medioDeTransporte = unTransporte }

  method peso() = pesoPropio + medioDeTransporte.peso()
  method puedeLlamar() = false
}

object bicicleta {
  method peso() = 5
}

object camion {
  var cantidadAcoplados = 1

  method cambiarAcoplados(cantidad) { cantidadAcoplados = cantidad }
  method peso() = 500 * cantidadAcoplados
}

object chuckNorris {
  method peso() = 80
  method puedeLlamar() = true
}

object neo {
  var saldo = 0

  method cambiarCredito(unMonto) { saldo = unMonto }
  method peso() = 0
  method puedeLlamar() = saldo > 0
}

object paloma {
  method peso() = 1
  method puedeLlamar() = true
}

object puenteDeBrooklyn {
  method puedePasar(mensajero) = mensajero.peso() <= 1000
}

object laMatrix {
  method puedePasar(mensajero) = mensajero.puedeLlamar()
}

class Paquete {
  var pagado = false
  var destinoActual = puenteDeBrooklyn

  method cambiarDestino(unDestino) { destinoActual = unDestino }
  method pagar() { pagado = true }

  method precio() = 50
  method estaPago() = pagado
  method puedeSerEntregadoPor(mensajero) =
    pagado and destinoActual.puedePasar(mensajero)
}

class Paquetito {
  method precio() = 0
  method estaPago() = true
  method puedeSerEntregadoPor(mensajero) = true
}

class PaquetonViajero {
  const listaDestinos
  var montoPagado = 0

  method pagar(monto) { montoPagado += monto }

  method precio() = 100 * listaDestinos.size()
  method estaPago() = montoPagado >= self.precio()
  method puedeSerEntregadoPor(mensajero) =
    self.estaPago() and listaDestinos.all({ d => d.puedePasar(mensajero) })
}

class PaqueteLiviano {
  var pagado = false

  method pagar() { pagado = true }

  method precio() = 70
  method estaPago() = pagado
  method puedeSerEntregadoPor(mensajero) =
    pagado and mensajero.peso() < 100
}

object mensajeria {
  const listaMensajeros = []
  const listaPendientes = []
  var totalFacturado = 0

  method mensajeros() = listaMensajeros
  method pendientes() = listaPendientes
  method facturacion() = totalFacturado

  method contratar(unMensajero) { listaMensajeros.add(unMensajero) }
  method despedir(unMensajero) { listaMensajeros.remove(unMensajero) }
  method despedirATodos() { listaMensajeros.clear() }
  method esGrande() = listaMensajeros.size() > 2
  method puedeEntregarElPrimero(unPaquete) =
    unPaquete.puedeSerEntregadoPor(listaMensajeros.first())
  method pesoDelUltimo() = listaMensajeros.last().peso()

  method puedeEntregar(paquete) =
    listaMensajeros.any({ m => paquete.puedeSerEntregadoPor(m) })

  method mensajerosQuePuedenLlevar(paquete) =
    listaMensajeros.filter({ m => paquete.puedeSerEntregadoPor(m) })

  method pesoPromedio() =
    listaMensajeros.sum({ m => m.peso() }) / listaMensajeros.size()
  method tieneSobrepeso() = self.pesoPromedio() > 500

  method enviar(paquete) {
    if (self.puedeEntregar(paquete)) {
      totalFacturado += paquete.precio()
    } else {
      listaPendientes.add(paquete)
    }
  }

  method enviarTodos(paquetes) {
    paquetes.forEach({ p => self.enviar(p) })
  }

  method enviarPendienteMasCaro() {
    if (not listaPendientes.isEmpty()) {
      const masCaro = listaPendientes.max({ p => p.precio() })
      if (self.puedeEntregar(masCaro)) {
        listaPendientes.remove(masCaro)
        totalFacturado += masCaro.precio()
      }
    }
  }
}