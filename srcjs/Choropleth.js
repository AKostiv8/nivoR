import React, { useState, useEffect } from 'react';
import { BsPauseCircle, BsPlayCircle } from "react-icons/bs";
import { IconContext } from "react-icons";
import { ResponsiveChoropleth } from '@nivo/geo';
import { data_globe } from "./data_globe";
import country from "./test.json";


function Choropleth(props) {
  //console.log(props.polygon_json)
  console.log(props)
  //console.log(props.data)

    const [rotateMap, setRotateMap] = useState(0);
    const [isActive, setIsActive] = useState(true);
    const [direction, setDirection] = useState('left')

    function toggle() {
      setIsActive(!isActive);
    }


    useEffect(() => {
      let interval = null;
      if (isActive) {
        interval = setInterval(() => {
                setRotateMap(rotateMap => {
                    if(direction === 'left') {
                        if(rotateMap === 360) { setDirection('right') }
                        return(rotateMap + 1)
                    } else {
                        if(rotateMap === -360) { setDirection('left') }
                        return(rotateMap - 1)
                    }
                });
        }, 40);
      } else if (!isActive) {
        clearInterval(interval);
      }
      return () => clearInterval(interval);
    }, [isActive, rotateMap, direction]);
    //   console.log(rotateMap)


    return(
    <div style={{height: '400px'}}>
      <IconContext.Provider value={{ color: "white", className: "global-class-name" }}>
          <div onClick={toggle}>
              {isActive ? <BsPauseCircle /> : <BsPlayCircle />}
          </div>
      </IconContext.Provider>

      <ResponsiveChoropleth
          data={props.data}
          features={props.polygon_json.features}
          margin={{ top: 0, right: 0, bottom: 0, left: 0 }}
          colors={['#9b0034']}
          domain={[ 0, 1000000 ]}
          unknownColor="#666666"
          label="properties.name"
          valueFormat=".2s"
          projectionType={props.projectionType}
          projectionScale={200}
          projectionTranslation={[ 0.4, 0.5 ]}
          projectionRotation={[ rotateMap, -5, 0 ]}
          enableGraticule={true}
          graticuleLineColor="#dddddd"
          borderWidth={0.5}
          borderColor="#989627"
          tooltip={e => {
              return (
                  <div
                      style={{
                          background: "#0e1318",
                          padding: "9px 12px",
                          border: "1px solid black",
                          borderRadius: "25px",
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "center",
                          flexDirection: "column",
                          color: "#9d9e9f",
                      }}
                  >
                      {e.feature.properties.name}:{" "}
                      {e.feature.value
                          ? e.feature.value.toLocaleString()
                          : "No race data"}
                  </div>
              );
          }}
          onClick={(data) => {
              localStorage.clear();
              localStorage.setItem('shinyStore-ex2\\choropleth_clicked', JSON.stringify(data));
              // console.log(
              //     data.id
              // );
             }}
      />
    </div>
  )
}

export default Choropleth;

