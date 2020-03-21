import { autoserialize, autoserializeAs } from 'cerialize'
export class Position {
    @autoserialize public longitude: number;
    @autoserialize public latitude: number;
    @autoserializeAs(Date) public timestamp: Date;
    @autoserialize public mocked: boolean;
    @autoserialize public accuracy: number;
    @autoserialize public altitude: number;
    @autoserialize public heading: number;
    @autoserialize public speed: number;
    @autoserialize public speedAccuracy: number;

    constructor(
        longitude: number,
        latitude: number,
        timestamp: Date,
        mocked: boolean,
        accuracy: number,
        altitude: number,
        heading: number,
        speed: number,
        speedAccuracy: number
    ) {
        this.longitude = longitude;
        this.latitude = latitude;
        this.timestamp = timestamp;
        this.mocked = mocked;
        this.accuracy = accuracy;
        this.altitude = altitude;
        this.heading = heading;
        this.speed = speed;
        this.speedAccuracy = speedAccuracy;
    }
}
