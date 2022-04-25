import React, { useState, useEffect } from 'react';
import { BsPauseCircle, BsPlayCircle } from "react-icons/bs";
import { IconContext } from "react-icons";
import { ResponsiveChoropleth } from '@nivo/geo';


function Choropleth(props) {
  // console.log(props.interective_rotate)
  // console.log(props)
  // console.log('Props:')
  // console.log(props.polygon_json)
  // console.log('Constant:')
  // console.log(country)

    const [rotateMap, setRotateMap] = useState(props.rotate_x);
    const [isActive, setIsActive] = useState(props.interective_rotate);
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
    <div style={{height: props.height}}>
      <IconContext.Provider value={{ color: props.pausePlayBTNcolor, className: "global-class-name" }}>
          <div onClick={toggle}>
              {isActive ? <BsPauseCircle /> : <BsPlayCircle />}
          </div>
      </IconContext.Provider>

      <ResponsiveChoropleth
          data={props.data}
          features={(props.polygon_json).features}
          margin={{ top: props.margin_top,
                    right: props.margin_right,
                    bottom: props.margin_bottom,
                    left: props.margin_left }}
          colors={[props.polygonColors]}
          domain={[ 0, 1000000 ]}
          unknownColor={props.unknownColor}
          label="properties.name"
          valueFormat=".2s"
          projectionType={props.projectionType}
          projectionScale={props.projectionScale}
          projectionTranslation={[ props.projectionTranslation_x, props.projectionTranslation_y ]}
          projectionRotation={[ rotateMap, props.rotate_y, props.rotate_z ]}
          enableGraticule={true}
          graticuleLineColor="#dddddd"
          borderWidth={props.border_width}
          borderColor={props.border_Color}
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
                          : props.tooltipText}
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

